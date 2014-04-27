package com.finegamedesign.surface
{
    import flash.display.MovieClip;
    import flash.display.SimpleButton;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.text.TextField;
    import flash.utils.getTimer;

    import org.flixel.plugin.photonstorm.API.FlxKongregate;
    // import com.newgrounds.API;

    public dynamic class Main extends MovieClip
    {
        [Embed(source="../../../../sfx/chime.mp3")]
        private static var completeClass:Class;
        private var complete:Sound = new completeClass();
        [Embed(source="../../../../sfx/chime.mp3")]
        private static var correctClass:Class;
        private var correct:Sound = new correctClass();
        [Embed(source="../../../../sfx/die.mp3")]
        private static var wrongClass:Class;
        private var wrong:Sound = new wrongClass();
        [Embed(source="../../../../sfx/correct.mp3")]
        private static var contagionClass:Class;
        private var contagion:Sound = new contagionClass();
        [Embed(source="../../../../sfx/correct.mp3")]
        private static var dieClass:Class;
        private var die:Sound = new dieClass();
        private var loop:Sound; // Loop = new Loop();
        private var loopChannel:SoundChannel;

        public var air:MovieClip;
        public var background:MovieClip;
        public var feedback:MovieClip;
        public var highScore_txt:TextField;
        public var level_txt:TextField;
        public var maxLevel_txt:TextField;
        public var room:MovieClip;
        public var score_txt:TextField;
        public var restartTrial_btn:SimpleButton;

        private var inTrial:Boolean;
        private var level:int;
        private var maxLevel:int;
        private var model:Model;
        private var view:View;

        public function Main()
        {
            if (stage) {
                init(null);
            }
            else {
                addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
            }
        }

        public function init(event:Event=null):void
        {
            inTrial = false;
            level = 1;
            LevelSelect.onSelect = load;
            LevelLoader.onLoaded = trial;
            model = new Model();
            model.onContagion = contagion.play;
            model.onDie = correct.play;
            model.onDeselect = wrong.play;
            view = new View();
            // trial();
            addEventListener(Event.ENTER_FRAME, update, false, 0, true);
            // level_txt.addEventListener(MouseEvent.CLICK, cheatLevel, false, 0, true);
            restartTrial_btn.addEventListener(MouseEvent.CLICK, restartTrial, false, 0, true);
            // API.connect(root, "", "");
        }

        private function cheatLevel(event:MouseEvent):void
        {
            level++;
            if (maxLevel < level) {
                level = 1;
            }
        }

        private function restartTrial(e:MouseEvent):void
        {
            view.clear();
            next();
            // lose();
        }

        public function load(level:int):void
        {
            this.level = level;
            LevelLoader.load(level);
            gotoAndPlay("level");
            // loopChannel = loop.play(0, int.MAX_VALUE);
        }

        public function trial():void
        {
            inTrial = true;
            mouseChildren = true;
            model.populate(level, DiverClip.instance.x, DiverClip.instance.y, DiverClip.instance.y,
                PearlClip.instances, this.background.getRect(this));
            view.populate(model, this);
        }

        private function updateHudText():void
        {
            // trace("updateHudText: ", score, highScore);
            score_txt.text = Model.score.toString();
            // highScore_txt.text = Model.highScore.toString();
            // level_txt.text = level.toString();
            // maxLevel_txt.text = maxLevel.toString();
        }

        private function update(event:Event):void
        {
            var now:int = getTimer();
            // After stage is setup, connect to Kongregate.
            // http://flixel.org/forums/index.php?topic=293.0
            // http://www.photonstorm.com/tags/kongregate
            if (! FlxKongregate.hasLoaded && stage != null) {
                FlxKongregate.stage = stage;
                FlxKongregate.init(FlxKongregate.connect);
            }
            if (inTrial) {
                var win:int = model.update(now);
                view.update();
                result(win);
            }
            else {
                // view.update();
                if ("next" == feedback.currentLabel) {
                    next();
                }
            }
            updateHudText();
        }

        private function result(winning:int):void
        {
            if (!inTrial) {
                return;
            }
            if (winning <= -1) {
                lose();
            }
            else if (1 <= winning) {
                win();
            }
        }

        private function win():void
        {
            reset();
            inTrial = false;
            level++;
            if (maxLevel < level) {
                // level = 0;
                feedback.gotoAndPlay("complete");
                complete.play();
            }
            else {
                feedback.gotoAndPlay("correct");
                correct.play();
            }
            FlxKongregate.api.stats.submit("Score", Model.score);
            // API.postScore("Score", model.score);
        }

        private function reset():void
        {
            PearlClip.instances = [];
            if (null != loopChannel) {
                loopChannel.stop();
            }
        }

        private function lose():void
        {
            reset();
            inTrial = false;
            FlxKongregate.api.stats.submit("Score", Model.score);
            // API.postScore("Score", model.score);
            mouseChildren = false;
            feedback.gotoAndPlay("wrong");
            wrong.play();
        }

        public function next():void
        {
            feedback.gotoAndPlay("none");
            mouseChildren = true;
            restart();
        }

        public function restart():void
        {
            // level = 1;
            // trial();
            mouseChildren = true;
            gotoAndPlay(1);
        }
    }
}
