package com.finegamedesign.surface
{
    import flash.display.DisplayObject;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Model
    {
        internal var air:Number;
        internal var diverLabel:String;
        internal var diverLabelDirty:Boolean;
        internal var onContagion:Function;
        internal var onDeselect:Function;
        internal var onDie:Function;
        internal var highScore:int;
        internal var score:int;
        internal var level:int;
        internal var levelScores:Array;
        internal var diver:Point;
        internal var gravityVector:Number;
        internal var target:Point;
        internal var rotation:Number;
        internal var vector:Point;
        private var bounds:Rectangle;
        private var diverWidth:Number = 32;
        private var min:Number = 0.0001;
        private var now:int;
        private var elapsed:Number;
        private var pearls:Array;
        private var pearlClips:Array;
        private var pearlsCollected:int;
        private var previousTime:int;
        private var surfaceY:Number;

        public function Model()
        {
            air = 1.0;
            score = 0;
            highScore = 0;
            levelScores = [];
            diver = new Point();
            target = new Point();
            vector = new Point();
            pearls = [];
        }

        internal function populate(level:int, diverX:Number, diverY:Number, surfaceY:Number,
                pearlClips:Array, bounds:Rectangle):void
        {
            if (null == levelScores[level]) {
                levelScores[level] = 0;
            }
            diver.x = diverX;
            diver.y = diverY;
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
                if (collision.hitTestPoint(diver.x, diver.y, true)) {
                    collision.alpha = 0.5;
                }
                else {
                    collision.alpha = 1.0;
                }
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

        private function move():void
        {
            diver.x += vector.x * elapsed;
            diver.y += vector.y * elapsed;
            var base:Number = 32.0;
            if (0 < elapsed) {
                vector.x *= base / elapsed;
                vector.y *= base / elapsed;
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
            var fast:Number = 0.08;
            var still:Point = new Point();
            if (fast <= Point.distance(vector, still)) {
                air -= exert * elapsed;
            }
            var inhale:Number = 0.0005;
            var exhale:Number = 0.00001;
            if (atSurface()) {
                air += inhale * elapsed;
            }
            else {
                air -= exhale * elapsed;
            }
            air = Math.max(0.0, Math.min(1.0, air));
        }

        private function atSurface():Boolean
        {
            return diver.y < surfaceY + blockWidth;
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
                    score += 100;
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
            if (winning <= -1) {
                diverLabel = "die";
            }
            else if (0 <= winning) {
                if (1 <= pearlsCollected && atSurface()) {
                    winning = 1;
                }
            }
            return winning;
        }
    }
}
