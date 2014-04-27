package com.finegamedesign.surface
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Model
    {
        internal static var levelScores:Array = [];
        internal static var score:int = 0;

        internal var air:Number;
        internal var diverLabel:String;
        internal var diverLabelDirty:Boolean;
        internal var onContagion:Function;
        internal var onDeselect:Function;
        internal var onDie:Function;
        internal var highScore:int;
        internal var level:int;
        internal var levelScore:int;
        internal var diver:Point;
        internal var gravityVector:Number;
        internal var target:Point;
        internal var rotation:Number;
        internal var vector:Point;
        private var accumulator:int;
        private var bounds:Rectangle;
        private var fatigue:Number;
        private var diverWidth:Number = 32;
        private var min:Number = 0.0001;
        private var now:int;
        private var elapsed:Number;
        private var pearls:Array;
        private var pearlClips:Array;
        private var pearlsCollected:int;
        private var previousTime:int;
        private var shark:Shark = new Shark();
        private var surfaceY:Number;

        public function Model()
        {
            air = 1.0;
            score = 0;
            highScore = 0;
            levelScores = [];
            pearls = [];
            diver = new Point();
            target = new Point();
            vector = new Point();
        }

        /**
         * 14/4/26 Load level.  Tyriq expects to fix swimmer does not move.
         */
        internal function populate(level:int, diverX:Number, diverY:Number, surfaceY:Number,
                pearlClips:Array, bounds:Rectangle):void
        {
            this.level = level;
            if (null == levelScores[level]) {
                levelScores[level] = 0;
            }
            levelScore = 0;
            accumulator = 0;
            diver.x = diverX;
            diver.y = diverY;
            target.x = -1;
            target.y = -1;
            vector.x = 0;
            vector.y = 0;
            fatigue = 0.0;
            this.surfaceY = surfaceY;
            previousTime = -1;
            now = -1;
            elapsed = 0;
            pearlsCollected = 0;
            air = 1.0;
            pearls = [];
            this.pearlClips = pearlClips;
            for (var i:int = 0; i < pearlClips.length; i++) {
                pearls.push(new Point(pearlClips[i].x, pearlClips[i].y));
            }
            diverLabel = "idle";
            this.bounds = bounds;
            rotation = 0.0;
        }

        internal function strokeToward(x:Number, y:Number):void
        {
            target.x = x;
            target.y = y;
            var distance:Number = Point.distance(target, diver);
            var deadZone:Number = 32.0;
            if (deadZone <= distance) {
                var speed:Number = 0.1;
                vector.x = speed * (target.x - diver.x) / distance;
                vector.y = speed * (target.y - diver.y) / distance;
                diverLabel = "swim";
                diverLabelDirty = true;
                fatigue += 1.0 / 12;
                rotation = headFirst();
            }
        }

        private function headFirst():Number
        {
            var degree:Number = 0.0;
            if (0 < target.x) {
                var dx:Number = target.x - diver.x;
                var dy:Number = target.y - diver.y;
                degree = Math.atan2(dy, dx) * 180.0 / Math.PI;
                degree += 90.0;
            }
            return degree;
        }

        internal function clear():void
        {
        }

        internal function update(now:int):int
        {
            previousTime = 0 <= this.now ? this.now : now;
            this.now = now;
            elapsed = this.now - previousTime;
            bound();
            block();
            tangle();
            move();
            sink();
            breathe();
            collect();
            return win();
        }

        internal function animate(currentLabel:String):Boolean
        {
            var play:Boolean = false;
            if (diverLabel 
                    && (diverLabel != currentLabel || diverLabelDirty)) {
                play = true;
                diverLabelDirty = false;
            }
            return play;
        }

        private var blockWidth:Number = diverWidth / 3;

        private function bound():void
        {
            if (diver.x - blockWidth < bounds.left) {
                vector.x = Math.max(0.0, vector.x);
            }
            else if (bounds.right < diver.x + blockWidth) {
                vector.x = Math.min(0.0, vector.x);
            }
            if (diver.y - blockWidth < bounds.top) {
                vector.y = Math.max(0.0, vector.y);
            }
            else if (bounds.bottom < diver.y + blockWidth) {
                vector.y = Math.min(0.0, vector.y);
            }
        }

        private function block():void
        {
            var collision:DisplayObject = LevelLoader.instance["collision"];
            if (null != collision) {
                /*#
                if (collision.hitTestPoint(diver.x, diver.y, true)) {
                    collision.alpha = 0.5;
                }
                else {
                    collision.alpha = 1.0;
                }
                #*/
                if (collision.hitTestPoint(diver.x - blockWidth, diver.y, true)) {
                    vector.x = Math.max(0.0, vector.x);
                }
                else if (collision.hitTestPoint(diver.x + blockWidth, diver.y, true)) {
                    vector.x = Math.min(0.0, vector.x);
                }
                if (collision.hitTestPoint(diver.x, diver.y - blockWidth, true)) {
                    vector.y = Math.max(0.0, vector.y);
                }
                else if (collision.hitTestPoint(diver.x, diver.y + blockWidth, true)) {
                    vector.y = Math.min(0.0, vector.y);
                }
            }
        }

        private function tangle():void
        {
            if (tangled()) {
                accumulator += 3.0 * elapsed;
            }
        }

        private function tangled():Boolean
        {
            var kelps:Array = KelpClip.instances;
            for (var k:int = 0; k < kelps.length; k++) {
                if (colliding(kelps[k])) {
                    return true;
                }
            }
            return false;
        }

        private function move():void
        {
            diver.x += vector.x * elapsed;
            diver.y += vector.y * elapsed;
            accumulator += elapsed;
            var base:Number = 32.0;
            var threshold:int = 33;
            while (threshold <= accumulator) {
                vector.x *= base / elapsed;
                vector.y *= base / elapsed;
                accumulator -= threshold;
            }
            if (Math.abs(vector.x) < min) {
                vector.x = 0;
            }
            if (Math.abs(vector.y) < min) {
                vector.y = 0;
            }
        }

        /**
         * If above surface, pull down.
         */
        private function sink():void
        {
            var gravity:Number = 0.0001;
            if (diver.y < surfaceY) {
                gravityVector += gravity * elapsed;
            }
            else if (surfaceY < diver.y && min < gravityVector) {
                gravityVector -= gravity * elapsed;
            }
            else {
                gravityVector = 0;
            }
            diver.y += gravityVector * elapsed;
        }

        private function breathe():void
        {
            var exert:Number = 0.0005;
            /*-
            var fast:Number = 0.08;
            var still:Point = new Point();
            if (fast <= Point.distance(vector, still)) {
                air -= exert * elapsed;
            }
            -*/
            if (0 < fatigue) {
                var exerted:Number = Math.min(fatigue, exert * elapsed);
                air -= exerted;
                fatigue -= exerted;
            }
            var inhale:Number = 0.0005;
            var exhale:Number = // 0.00001;
                                0.00002;
            if (atSurface()) {
                air += inhale * elapsed;
            }
            else {
                air -= exhale * elapsed;
            }
            air += breatheAirPocket(inhale * elapsed);
            air = Math.max(0.0, Math.min(1.0, air));
        }

        private function breatheAirPocket(mayAdd:Number):Number
        {
            for (var i:int = 0; i < AirPocketClip.instances.length; i++) {
                var pocket:AirPocketClip = AirPocketClip.instances[i];
                if (colliding(pocket)) {
                    pocket.play();
                    return mayAdd;
                }
            }
            return 0.0;
        }

        private function colliding(collision:DisplayObject):Boolean
        {
            if (collision.hitTestPoint(diver.x - blockWidth, diver.y, true)) {
                return true;
            }
            else if (collision.hitTestPoint(diver.x + blockWidth, diver.y, true)) {
                return true;
            }
            if (collision.hitTestPoint(diver.x, diver.y - blockWidth, true)) {
                return true;
            }
            else if (collision.hitTestPoint(diver.x, diver.y + blockWidth, true)) {
                return true;
            }
            return false;
        }

        private function atSurface():Boolean
        {
            return diver.y < surfaceY + blockWidth;
        }

        private function attacked():Boolean
        {
            var sharks:Array = SharkClip.instances;
            for (var s:int = 0; s < sharks.length; s++) {
                shark.move(sharks[s], bounds, elapsed);
                if (colliding(sharks[s])) {
                    return true;
                }
            }
            return false;
        }

        private function collect():void
        {
            for (var i:int = pearls.length - 1; 0 <= i; i--) {
                var pearl:Point = pearls[i];
                var distance:Number = Point.distance(diver, pearl);
                if (distance < diverWidth) {
                    pearl.x = Number.MIN_VALUE;
                    pearl.y = Number.MIN_VALUE;
                    pearlClips[i].gotoAndPlay("collect");
                    levelScore += 1;
                    pearlsCollected++;
                    // onContagion();  // why does diver jump?
                }
            }
        }

        /**
         * @return  0 continue, 1: win, -1: lose.
         */
        private function win():int
        {
            var winning:int = 0 < air ? 0 : -1;
            if (attacked()) {
                winning = -1;
            }
            if (winning <= -1) {
                diverLabel = "die";
            }
            else if (0 <= winning) {
                if (1 <= pearlsCollected && atSurface()) {
                    winning = 1;
                    updateScore();
                }
            }
            return winning;
        }

        private function updateScore():int
        {
            if (levelScores[level] < levelScore) {
                levelScores[level] = levelScore;
            }
            var sum:int = 0;
            for each (var n:int in levelScores) {
                sum += n;
            }
            score = sum;
            return sum;
        }
    }
}
