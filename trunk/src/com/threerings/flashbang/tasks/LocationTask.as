// Flashbang - a framework for creating Flash games
// http://code.google.com/p/flashbang/
//
// This library is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public License
// along with this library.  If not, see <http://www.gnu.org/licenses/>.
//
// Copyright 2008 Three Rings Design
//
// $Id$

package com.threerings.flashbang.tasks {

import com.threerings.flashbang.GameObject;
import com.threerings.flashbang.ObjectTask;
import com.threerings.flashbang.components.LocationComponent;

import flash.display.DisplayObject;

import mx.effects.easing.*;

public class LocationTask extends InterpolatingTask
    implements ObjectTask
{
    public static function CreateLinear (x :Number, y :Number, time :Number,
        disp :DisplayObject = null) :LocationTask
    {
        return new LocationTask(x, y, time, mx.effects.easing.Linear.easeNone, disp);
    }

    public static function CreateSmooth (x :Number, y :Number, time :Number,
        disp :DisplayObject = null) :LocationTask
    {
        return new LocationTask(x, y, time, mx.effects.easing.Cubic.easeInOut, disp);
    }

    public static function CreateEaseIn (x :Number, y :Number, time :Number,
        disp :DisplayObject = null) :LocationTask
    {
        return new LocationTask(x, y, time, mx.effects.easing.Cubic.easeIn, disp);
    }

    public static function CreateEaseOut (x :Number, y :Number, time :Number,
        disp :DisplayObject = null) :LocationTask
    {
        return new LocationTask(x, y, time, mx.effects.easing.Cubic.easeOut, disp);
    }

    public function LocationTask (x :Number, y :Number, time :Number = 0,
        easingFn :Function = null, disp :DisplayObject = null)
    {
        super(time, easingFn);
        _toX = x;
        _toY = y;
        _dispOverride = DisplayObjectWrapper.create(disp);
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        var lc :LocationComponent =
            (!_dispOverride.isNull ? _dispOverride : obj as LocationComponent);

        if (null == lc) {
            throw new Error("obj does not implement LocationComponent");
        }

        if (0 == _elapsedTime) {
            _fromX = lc.x;
            _fromY = lc.y;
        }

        _elapsedTime += dt;

        lc.x = interpolate(_fromX, _toX, _elapsedTime, _totalTime, _easingFn);
        lc.y = interpolate(_fromY, _toY, _elapsedTime, _totalTime, _easingFn);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new LocationTask(_toX, _toY, _totalTime, _easingFn, _dispOverride.displayObject);
    }

    protected var _toX :Number;
    protected var _toY :Number;
    protected var _fromX :Number;
    protected var _fromY :Number;
    protected var _dispOverride :DisplayObjectWrapper;
}

}
