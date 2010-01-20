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

import com.threerings.flashbang.*;
import com.threerings.flashbang.components.*;
import com.threerings.flashbang.objects.*;

public class WaitOnPredicateTask implements ObjectTask
{
    public function WaitOnPredicateTask (pred :Function, ...args)
    {
        _pred = pred;
        _args = args;
    }

    public function update (dt :Number, obj :GameObject) :Boolean
    {
        return _pred.apply(null, _args);
    }

    public function clone () :ObjectTask
    {
        var task :WaitOnPredicateTask = new WaitOnPredicateTask(_pred);
        // Work around for the pain associated with passing a normal Array as a varargs Array
        task._args = _args;
        return task;
    }

    public function receiveMessage (msg :ObjectMessage) :Boolean
    {
        return false;
    }

    protected var _pred :Function;
    protected var _args :Array;
}

}
