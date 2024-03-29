//
// $Id$
//
// Flashbang - a framework for creating Flash games
// Copyright (C) 2008-2010 Three Rings Design, Inc., All Rights Reserved
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

package com.threerings.flashbang.tasks {

import com.threerings.flashbang.GameObject;
import com.threerings.flashbang.ObjectTask;

public class FunctionTask
    implements ObjectTask
{
    public function FunctionTask (fn :Function, ...args)
    {
        if (null == fn) {
            throw new ArgumentError("fn must be non-null");
        }

        _fn = fn;
        _args = args;
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        // If Function returns "false", the FunctionTask will not complete.
        // Any other return value (including void) will cause it to complete immediately.
        return (_fn.apply(null, _args) !== false);
    }

    public function clone () :ObjectTask
    {
        var task :FunctionTask = new FunctionTask(_fn);
        // Work around for the pain associated with passing a normal Array as a varargs Array
        task._args = _args;
        return task;
    }

    protected var _fn :Function;
    protected var _args :Array;
}

}
