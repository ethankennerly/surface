package com.finegamedesign.surface
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.text.TextField;

    public class LevelSelect extends Sprite
    {
        /**
         * @param   level:int
         */
        internal static var onSelect:Function;

        /**
         * Level buttons, horizontally centered, vertical from top.
         */
        public function LevelSelect() 
        {
            super();
            for (var c:int = numChildren - 1; 0 <= c; c--) {
                removeChildAt(c);
            }
            var columnCount:int = 3;
            var columnWidth:int = 100;
            for (var i:int = 0; i < LevelLoader.levels.length; i++) {
                var btn:LevelTile = new LevelTile();
                btn.x = columnWidth * ((i % columnCount) - 1);
                btn.y = columnWidth * int(i / columnCount);
                btn.txt.text = (i + 1).toString();
                btn.txt.mouseEnabled = false;
                btn.name = "_" + (i + 1).toString();
                btn.addEventListener(MouseEvent.CLICK,
                    selectLevel, false, 0, true);
                addChild(btn);
            }
        }

        private function selectLevel(event:MouseEvent):void
        {
            var level:int = parseInt(event.currentTarget.name.split("_")[1]);
            onSelect(level);
        }
    }
}
