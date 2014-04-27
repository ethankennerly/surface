package com.finegamedesign.surface
{
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class View
    {
        internal var main:Main;
        internal var model:Model;
        private var isMouseDown:Boolean;
        private var mouseJustPressed:Boolean;

        public function View()
        {
        }

        internal function populate(model:Model, main:Main):void
        {
            this.model = model;
            this.main = main;
            main.stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            main.stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
        }

        private function mouseDown(event:MouseEvent):void
        {
            mouseJustPressed = !isMouseDown;
            if (mouseJustPressed) {
                model.strokeToward(event.currentTarget.mouseX,
                    event.currentTarget.mouseY);
            }
            isMouseDown = true;
        }

        private function mouseUp(event:MouseEvent):void
        {
            mouseJustPressed = false;
            isMouseDown = false;
        }

        internal function update():void
        {
            if (DiverClip.instance) {
                animate(model, DiverClip.instance);
            }
            if (model && main) {
                gotoFraction(model.air, main.air);
            }
        }

        private function gotoFraction(fraction:Number, mc:MovieClip):void
        {
            var frame:int = fraction * (mc.totalFrames - 1) + 1;
            mc.gotoAndStop(frame);
        }

        internal function clear():void
        {
            model.clear();
        }

        /**
         * position
         * rotation
         * frame
         */
        internal function animate(model:Model, diver:DiverClip):void
        {
            diver.x = model.diver.x;
            diver.y = model.diver.y;
            diver.rotation = model.rotation;
            var body:MovieClip = diver.body;
            if (model.animate(body.currentLabel)) {
                body.gotoAndPlay(model.diverLabel);
            }
        }

        internal static function exhaust():void
        {
            var clip:DiverClip = DiverClip.instance;
            var exhaust:ExhaustClip = new ExhaustClip();
            exhaust.x = clip.x;
            exhaust.y = clip.y;
            clip.parent.addChild(exhaust);
        }
    }
}
