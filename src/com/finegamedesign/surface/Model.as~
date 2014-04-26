package com.finegamedesign.facetnated
{
    public class Model
    {
        internal static const EMPTY:int = -1;

        internal static var levels:Array = [
            {colorCount: 2, shapeCount: 2, columnCount: 4, rowCount: 3},
            {colorCount: 3, shapeCount: 2, columnCount: 5, rowCount: 3},
            {colorCount: 2, shapeCount: 3, columnCount: 5, rowCount: 3},
            {colorCount: 3, shapeCount: 3, columnCount: 5, rowCount: 3},
            {colorCount: 3, shapeCount: 3, columnCount: 6, rowCount: 4},
            {colorCount: 4, shapeCount: 3, columnCount: 6, rowCount: 4},
            {colorCount: 4, shapeCount: 4, columnCount: 6, rowCount: 4},
            {colorCount: 4, shapeCount: 4, columnCount: 6, rowCount: 4},
            {colorCount: 4, shapeCount: 4, columnCount: 7, rowCount: 5},
            {colorCount: 5, shapeCount: 5, columnCount: 7, rowCount: 5},
            {colorCount: 5, shapeCount: 5, columnCount: 8, rowCount: 6},
            {colorCount: 5, shapeCount: 5, columnCount: 9, rowCount: 7}
        ];

        internal var kill:int;
        internal var maxKill:int;
        internal var cellCount:int;
        internal var colorCount:int;
        internal var columnCount:int;
        internal var onContagion:Function;
        internal var onDeselect:Function;
        internal var onDie:Function;
        internal var rowCount:int;
        internal var shapeCount:int;
        internal var selectColor:Boolean;
        internal var selected:Array;
        internal var selectShape:Boolean;
        internal var table:Array;
        internal var highScore:int;
        internal var score:int;
        internal var restartScore:int;

        public function Model()
        {
            score = 0;
            highScore = 0;
            restartScore = 0;
        }

        internal function populate(levelParams:Object):void
        {
            for (var param:String in levelParams) {
                this[param] = levelParams[param];
            }
            table = [];
            cellCount = rowCount * columnCount;
            for (var c:int = 0; c < cellCount; c++) {
                var color:int = c % colorCount;
                var shape:int = int(c / colorCount) % shapeCount;
                var cell:Cell = new Cell();
                cell.color = color;
                cell.shape = shape;
                table.push(cell);
            }
            shuffle(table);
            for (c = 0; c < cellCount; c++) {
                table[c].index = c;
            }
            selected = [];
            kill = 0;
            restartScore = score;
            maxKill = columnCount * rowCount;
        }

        private function shuffle(array:Array):void
        {
            for (var i:int = array.length - 1; 1 <= i; i--) {
                var j:int = (i + 1) * Math.random();
                var tmp:* = array[i];
                array[i] = array[j];
                array[j] = tmp;
            }
        }

        internal function indexAt(column:int, row:int):int
        {
            return row * columnCount + column;
        }

        /**
         * Nothing selected yet.
         * Just mouse down.  Select that cell's address.  Selected is translucent.
         * Just mouse over and down adjacent to last selected address.  If matches properties of selection, then select that address.
         * Just mouse over and down not adjacent.  Do nothing.
         * Mouse up.  Judge selection of cell addresses.  Clear selection.  Delete the cells.
         */
        internal function select(i:int):Boolean
        {
            var push:Boolean = false;
            if (selected.length == 0) {
                push = true;
                selectColor = true;
                selectShape = true;
            }
            else {
                var tail:int = selected[selected.length - 1];
                if (tail == i) {
                    selected.pop();
                }
                else if (adjacent(tail, i)) {
                    if (selectColor) {
                        if (table[tail].color == table[i].color) {
                            push = true;
                            if (table[tail].shape != table[i].shape) {
                                selectShape = false;
                            }
                        }
                    }
                    if (selectShape) {
                        if (table[tail].shape == table[i].shape) {
                            push = true;
                            if (table[tail].color != table[i].color) {
                                selectColor = false;
                            }
                        }
                    }
                }
            }
            if (push) {
                var index:int = selected.indexOf(i);
                if (index <= -1) {
                    selected.push(i);
                    if (null != onContagion) {
                        onContagion();
                    }
                }
                else {
                    selected.splice(index, 999);
                    push = false;
                    if (null != onDeselect) {
                        onDeselect();
                    }
                }
            }
            return push;
        }

        internal function adjacent(i:int, j:int):Boolean
        {
            var adjacent:Boolean = false;
            var column0:int = i % columnCount;
            var column1:int = j % columnCount;
            if (Math.abs(column1 - column0) <= 1) {
                var row0:int = i / columnCount;
                var row1:int = j / columnCount;
                if (Math.abs(row1 - row0) <= 1) {
                    adjacent = true;
                }
            }
            return adjacent;
        }

        /**
         * Removed addresses if 3 or more.
         * Set index to EMPTY and cell to null, in case view still refers to cell.
         */
        internal function judge():Array
        {
            var selectedMin:int = 3;
            var removed:Array = [];
            if (selectedMin <= selected.length) {
                removed = selected.slice();
                // trace("Model.judge: removed " + removed);
                for each(var address:int in removed) {
                    table[address].index = EMPTY;
                    table[address] = null;
                }
                collapse(table);
                scoreUp(removed.length, selectColor, selectShape);
                if (null != onDie) {
                    onDie();
                }
            }
            selected = [];
            return removed;
        }
   
        /**
         * 10, 20, 40,  80, 160, 320, 640, 1280, 2560, 5120, ...
         */
        private function scoreUp(length:int, selectColor:Boolean, selectShape:Boolean):void
        {
            kill += length;
            if (!selectColor && selectShape) {
                length += 2;
            }
            var points:int = Math.pow(2, length);
            points *= 10;
            score += points;
            if (highScore < score) {
                highScore = score;
            }
        }

        /**
         * Swap some cells and their indexes in table.
         */
        private function collapse(table:Array):void
        {
            collapseDown(table);
            collapseLeft(table);
        }

        /**
         * Slide gems above empty cells down.
         */
        private function collapseDown(table:Array):void
        {
            // trace("Model.collapseDown: before " + diagram(table));
            for (var i:int = cellCount - 1; columnCount <= i; i--) {
                if (null == table[i]) {
                    var above:int = i - columnCount;
                    if (null != table[above]) {
                        for (var j:int = i; j < cellCount && table[j] == null; 
                                j += columnCount) {
                        }
                        j -= columnCount;
                        table[j] = table[above];
                        table[j].index = j;
                        table[above] = null;
                    }
                }
            }
            // trace("Model.collapseDown: after " + diagram(table));
        }

        /**
	     * Slide columns right of empty columns left.
         */
        private function collapseLeft(table:Array):void
        {
            // trace("Model.collapseLeft: before " + diagram(table));
            var i:int;
            var bottomLeft:int = (rowCount - 1) * columnCount;
            for (var column:int = 0; column < columnCount; column++) {
                i = bottomLeft + column;
                if (null == table[i]) {
                    var right:int = i + 1;
                    if (null != table[right]) {
                        for (var j:int = i; bottomLeft <= j && table[j] == null; 
                                j--) {
                        }
                        j++;
                        for (; 0 <= j; j -= columnCount, right -= columnCount) {
                            if (null != table[right]) {
                                table[j] = table[right];
                                table[j].index = j;
                                table[right] = null;
                            }
                        }
                    }
                }
            }
            // trace("Model.collapseLeft: after " + diagram(table));
        }

        internal function diagram(table:Array):String
        {
            var diagram:String = "cell count " + table.length;
            for (var i:int = 0; i < table.length; i++) {
                if (i % columnCount == 0) {
                    diagram += "\n";
                }
                diagram += table[i] == null ? ".." :
                    table[i].shape.toString() + table[i].color.toString();
            }
            return diagram;
        }

        /**
         * Remove all cells.
         * Rollback score.
         */
        internal function clear():void
        {
            for (var i:int = 0; i < table.length; i++) {
                if (null != table[i]) {
                    table[i].index = EMPTY;
                }
                table[i] = null;
            }
            score = restartScore;
        }

        internal function update():int
        {
            return win();
        }

        /**
         * TODO: Lose if no moves remaining.
         * @return  0 continue, 1: win, -1: lose.
         */
        private function win():int
        {
            var winning:int = 0;
            if (maxKill <= kill) {
                winning = 1;
            }
            else if (false) {
                winning = -1;
            }
            return winning;
        }
    }
}
