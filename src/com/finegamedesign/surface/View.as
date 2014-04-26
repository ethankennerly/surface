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

        /**
         */
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
                DiverClip.instance.x = model.diver.x;
                DiverClip.instance.y = model.diver.y;
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
    }
}
