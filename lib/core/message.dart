// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 *
 */

part of yun;

/**
 * all message must be serializable for isolate usage
 * classpath is reserved for reflection
 */
abstract class message extends base
{
  static final String classpath='/base/message';
  String get msgid;
  String originalmsgid;
  SendPort sender;

}

/**
 *
 */
abstract class internalmessage extends message
{
  static final String classpath='/base/message/internalmessage';
}

/**
 * to_map function must be implemented for pass to javascript so that router know how to translate it
 */
abstract class userdefinedmessage extends message
{
  static final String classpath='/base/message/userdefinedmessage';
  Map<String,String> to_map();
}

/**
 * aliaspath is reserved for finding the instance in main isolate quickly
 */
abstract class callbackmessage extends message
{
  static final String classpath='/base/message/callbackmessage';
  String aliaspath;
}



