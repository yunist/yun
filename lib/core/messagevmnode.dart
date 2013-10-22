// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 *
 */

part of yun;

class im_init extends internalmessage
{
  static final String classpath='/base/message/internalmessage/im_init';
  static const String symbol='internal.init';
  String get msgid=>symbol;
}

class im_close extends internalmessage
{
  static final String classpath='/base/message/internalmessage/im_close';
  static const String symbol='internal.close';
  String get msgid=>symbol;
}

class messagevmnode extends base
{
  String aliasname;
  String aliaspath='/';
  Symbol vmlibrary;
  Symbol vmclass;
  SendPort  vmport;
  messagevmrouter vmrouter;

  void receive_message_from_vm(callbackmessage msg)
  {

  }
}
