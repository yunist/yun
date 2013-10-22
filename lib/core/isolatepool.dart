// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 *
 */

part of yun;

abstract class vmmessage extends message
{
  static final String classpath='/base/message/vmmessage';
}


class vm_createinstance extends vmmessage
{
  static final String classpath='/base/message/vmmessage/vm_createinstance';
  static const String symbol='vm.createinstance';
  String get msgid=>symbol;
  String aliasname;
  String aliaspath;
  Symbol libraryname;
  Symbol classname;
  SendPort router;
  SendPort owner;
  String get json
  {

  }
}

class vm_closeinstance extends vmmessage
{
  static final String classpath='/base/message/vmmessage/vm_closeinstance';
  static const String symbol='vm.closeinstance';
  String get msgid=>symbol;
  String get json
  {

  }
}

abstract class yunvm extends base
{
  SendPort owner;
  SendPort router;
  String aliasname;
  String aliaspath;
  Map msghandles;

  yunvm(this.router,this.owner,this.aliasname,this.aliaspath)
  {
    msghandles={
       im_init.symbol:msg_init,
       im_close.symbol:msg_close,
    };
    build_msg_handle();
  }

  void post_message(message msg)
  {
    if (router!=null)
      {
        router.send(msg);
      }
  }

  void  post_to_owner(callbackmessage msg)
  {
    if (owner!=null)
    {
      msg.aliaspath=aliaspath;
      owner.send(msg);
    }
  }

  void receive_message(message msg)
  {
    Function func=msghandles[msg.msgid];
    if (func!=null) func(msg);
  }

  void msg_init(message msg)
  {

  }

  void msg_close(message msg)
  {

  }

  void build_msg_handle();
}


vm_main()
{
  String aliasname;
  String aliaspath;
  Symbol libraryname;
  Symbol classname;
  SendPort router;
  SendPort owner;
  yunvm vminstance;
  port.receive((msg, replyTo) {
    if (msg is vmmessage)
    {
      if (vminstance==null)
      {
        if (msg is vm_createinstance)
        {
          aliasname=msg.aliasname;
          aliaspath=msg.aliaspath;
          libraryname=msg.libraryname;
          classname=msg.classname;
          router=msg.router;
          owner=msg.owner;
          vminstance=CreateInstance(libraryname,classname,[router,owner,aliasname,aliaspath]);
        }
      }
      else
        switch ((msg as vmmessage).msgid)
        {
          case vm_closeinstance.symbol:
            if (vminstance!=null)
              {
                vminstance==null;
                port.close();
              }
            break;
        }

    } else if (msg is message)
    {
      msg.sender=replyTo;
      if (vminstance!=null) vminstance.receive_message(msg);
    }
  });
}

ReceivePort createa_main_receiver()
{
  var recvport=new ReceivePort();
  recvport.receive((msg,_)
      {
        if (msg is callbackmessage)
        {
          rootrouters.forEach((messagevmrouter router)
              {
                router.delivery_message_from_vm(msg);
              });
        }
      });
  return recvport;
}


class isolatepool extends base
{

}