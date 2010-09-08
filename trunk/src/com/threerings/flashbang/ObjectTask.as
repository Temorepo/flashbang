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

package com.threerings.flashbang {

public interface ObjectTask
{
    /**
     * Updates the ObjectTask.
     * Returns true if the task has completed, otherwise false.
     */
    function update (dt :Number, obj :GameObject) :Boolean;

    /** Returns a copy of the ObjectTask */
    function clone () :ObjectTask;

    /**
     * Called when the task's parent object receives a message.
     * Returns true if the task has completed, otherwise false.
     */
    function receiveMessage (msg :ObjectMessage) :Boolean;
}

}
