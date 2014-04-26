package com.finegamedesign.surface
{
    import flash.display.DisplayObjectContainer;
    import flash.display.MovieClip;
    import flash.events.MouseEvent;

    public class View
    {
        internal var model:Model;
        private var isMouseDown:Boolean;
        private var mouseJustPressed:Boolean;

        public function View()
        {
        }

        /**
         */
        internal function populate(model:Model, room:DisplayObjectContainer):void
        {
            this.model = model;
            room.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown, false, 0, true);
            room.addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
        }

        private function mouseDown(event:MouseEvent):void
        {
            mouseJustPressed = !isMouseDown;
            isMouseDown = true;
        }

        private function mouseUp(event:MouseEvent):void
        {
            mouseJustPressed = false;
            isMouseDown = false;
        }

        internal function update():void
        {
        }

        internal function clear():void
        {
            model.clear();
        }
    }
}
