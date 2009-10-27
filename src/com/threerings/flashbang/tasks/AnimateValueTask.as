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

import mx.effects.easing.*;

public class AnimateValueTask extends InterpolatingTask
{
    public static function CreateLinear (boxedValue :Object, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            boxedValue,
            targetValue,
            time,
            mx.effects.easing.Linear.easeNone);
    }

    public static function CreateSmooth (boxedValue :Object, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            boxedValue,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeInOut);
    }

    public static function CreateEaseIn (boxedValue :Object, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            boxedValue,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeIn);
    }

    public static function CreateEaseOut (boxedValue :Object, targetValue :Number, time :Number)
        :AnimateValueTask
    {
        return new AnimateValueTask(
            boxedValue,
            targetValue,
            time,
            mx.effects.easing.Cubic.easeOut);
    }

    public function AnimateValueTask (
        boxedValue :Object,
        targetValue :Number,
        time :Number = 0,
        easingFn :Function = null)
    {
        super(time, easingFn);

        if (null == boxedValue || !boxedValue.hasOwnProperty("value")) {
            throw new Error("boxedValue must be non null, and must contain a 'value' property");
        }

        _to = targetValue;
        _boxedValue = boxedValue;
    }

    override public function update (dt :Number, obj :GameObject) :Boolean
    {
        if (0 == _elapsedTime) {
            _from = (_boxedValue.value as Number);
        }

        _elapsedTime += dt;

        _boxedValue.value = interpolate(_from, _to, _elapsedTime, _totalTime, _easingFn);

        return (_elapsedTime >= _totalTime);
    }

    override public function clone () :ObjectTask
    {
        return new AnimateValueTask(_boxedValue, _to, _totalTime, _easingFn);
    }

    protected var _to :Number;
    protected var _from :Number;
    protected var _boxedValue :Object;
}

}
