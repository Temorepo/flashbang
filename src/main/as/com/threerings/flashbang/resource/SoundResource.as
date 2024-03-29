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

package com.threerings.flashbang.resource {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.media.Sound;
import flash.net.URLRequest;

public class SoundResource extends Resource
{
    /** Load params */

    /** A String containing the URL to load the Sound from.
     * (Mutually exclusive with EMBEDDED_CLASS).*/
    public static const URL :String = "url";

    /** The [Embed]'d class to load the Sound from. (Mutually exclusive with URL.) */
    public static const EMBEDDED_CLASS :String = "embeddedClass";

    /** The sound type. String. Valid values: "sfx", "music". Defaults to "sfx". */
    public static const TYPE :String = "type";

    /**
     * The sound's priority (if the AudioManager is out of sound channels, lower-priority sounds
     * will have their channels taken by higher-priority ones). int. Defaults to 0.
     */
    public static const PRIORITY :String = "priority";

    /** The sound's base volume. Number, between 0 and 1. Defaults to 1. */
    public static const VOLUME :String = "volume";

    /** The sound's base pan. Number, between -1 and 1. Defaults to 0. */
    public static const PAN :String = "pan";

    /**
     * A Boolean specifying whether this sound should be streamed. Streaming sounds can begin
     * playing immediately; they don't need to be completely downloaded first. Defaults to false.
     */
    public static const STREAM :String = "stream";

    /** Sound types */
    public static const TYPE_SFX :int = 0;
    public static const TYPE_MUSIC :int = 1;
    public static const TYPE__LIMIT :int = 2;

    public function SoundResource (resourceName :String, loadParams :Object)
    {
        super(resourceName, loadParams);
    }

    public function get sound () :Sound
    {
        return _sound;
    }

    public function get type () :int
    {
        return _type;
    }

    public function get priority () :int
    {
        return _priority;
    }

    public function get volume () :Number
    {
        return _volume;
    }

    public function get pan () :Number
    {
        return _pan;
    }

    override protected function load (onLoaded :Function, onLoadErr :Function) :void
    {
        _completeCallback = onLoaded;
        _errorCallback = onLoadErr;

        // parse loadParams
        var typeName :String = getLoadParam(TYPE, "sfx");
        _type = (typeName == "music" ? TYPE_MUSIC : TYPE_SFX);

        _priority = getLoadParam(PRIORITY, 0);
        _volume = getLoadParam(VOLUME, 1);
        _pan = getLoadParam(PAN, 0);

        if (hasLoadParam(URL)) {
            _sound = new Sound(new URLRequest(getLoadParam(URL)));

            var stream :Boolean =
                getLoadParam(STREAM, false) ||
                getLoadParam("completeImmediately", false); // legacy param name

            // If this is a streaming sound, we don't wait for it to finish loading before
            // we make it available. Sounds loaded in this manner can be played without
            // issue as long as they download quickly enough.
            if (stream) {
                onInit();
            } else {
                _sound.addEventListener(Event.COMPLETE, onInit);
                _sound.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            }

        } else if (hasLoadParam(EMBEDDED_CLASS)) {
            try {
                var embeddedClass :Class = getLoadParam(EMBEDDED_CLASS);
                if (embeddedClass == null) {
                    onError("missing embedded class!");
                } else {
                    _sound = Sound(new embeddedClass());
                }
            } catch (e :Error) {
                onError(e.message);
                return;
            }
            onInit();

        } else {
            throw new Error("either 'url' or 'embeddedClass' must be specified in loadParams");
        }
    }

    override protected function unload () :void
    {
        try {
            if (null != _sound) {
                _sound.close();
            }
        } catch (e :Error) {
            // swallow the exception
        }
        _sound = null;
    }

    protected function onInit (...ignored) :void
    {
        _completeCallback();
    }

    protected function onIOError (e :IOErrorEvent) :void
    {
        onError(e.text);
    }

    protected function onError (errText :String) :void
    {
        _errorCallback(createLoadErrorString(errText));
    }

    protected var _sound :Sound;
    protected var _type :int;
    protected var _priority :int;
    protected var _volume :Number;
    protected var _pan :Number;

    protected var _completeCallback :Function;
    protected var _errorCallback :Function;
}

}
