// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * need to be rewritten. js cannot run in dart vm
 */

part of yun;

abstract class routermessage extends internalmessage
{
  static final String classpath='/base/message/internalmessage/routermessage';
}

class rm_clearroles extends routermessage
{
  static final String classpath='/base/message/internalmessage/routermessage/rm_clearroles';
  static const String symbol='rm.clearroles';
  String get msgid=>symbol;
}

abstract class vmcontext extends base
{

}

abstract class vmcondition extends base
{
  //bool checkit(vmcontext context);

  String jsstr;
  bool checkit(js.Proxy jscontext)
  {
    /// js should return a boolean to indicate it will excute something or not
    return jscontext.eval('(function(){'+jsstr+'}())');
  }

}

abstract class vmexecute extends base
{

  String jsstr;
  js.Proxy doit(js.Proxy jscontext)
  {
    /// js should return a map to indicate what's going to to. ex. sned translated message
    return jscontext.eval('(function(){'+jsstr+'}())');
  }

}

class ve_sendmessage extends vmexecute
{

}

class ve_setlocalstatus extends vmexecute
{

}

class ve_unsetlocalstatus extends vmexecute
{

}

class routervm extends yunvm
{

  Map<String,SendPort> childports={};
  Map<RegExp,Map<vmcondition,vmexecute>> routetable={};
  js.Proxy statustable=js.map({});

  routervm(router,owner,aliasname,aliaspath):super(router,owner,aliasname,aliaspath)
  {

  }

  void send_message(String aliasname, message msg)
  {
    var childport=childports[aliasname];
    if (childport!=null) childport.send(msg);
  }

  void receive_message(message msg)
  {
    if ((msg=parse_message(msg))!=null)
      super.receive_message(msg);
  }

  message parse_message(message msg)
  {
    var fmsg=msg;
    if (msg is userdefinedmessage)
      js.scoped((){
        var jscontext=build_js_environment(js.context,msg);
        routetable.forEach((RegExp msgpattern,Map<vmcondition,vmexecute> conditionmap){
          if (msgpattern.hasMatch(msg.msgid))
          {
            conditionmap.forEach((vmcondition cond,vmexecute exec){
                if (cond.checkit(jscontext))
                  jscontext=parse_js_result(jscontext, exec.doit(jscontext));
              });
            fmsg=null;
          }
        });
        //js.retain(statustable);
      });
    return fmsg;
  }

  js.Proxy build_js_environment(js.Proxy jscontext,userdefinedmessage msg)
  {
    var msgmap=js.map(msg.to_map());
    jscontext.srcmsg=msgmap;
    jscontext.status=statustable;
    return jscontext;
  }

  js.Proxy parse_js_result(js.Proxy jscontext,js.Proxy result)
  {

    statustable=jscontext.status;
    return jscontext;
  }

  void build_msg_handle()
  {
    msghandles[rm_clearroles.symbol]=msg_clearroles;
  }

  void msg_clearroles(message msg)
  {
    routetable={};
  }
}

class messagenodespool extends dictionary<String>
{

}

class messagevmrouter extends messagevmnode
{
  messagenodespool childnodes;
  messagenodespool wholenodes;

  void delivery_message_from_vm(callbackmessage msg)
  {
    if (vmrouter!=null)
      vmrouter.delivery_message_from_vm(msg);
    else
    {
      var node=wholenodes[msg.aliaspath] as messagevmnode;
      if (node!=null)
        node.receive_message_from_vm(msg);
    }
  }

  messagevmnode operator[](String aliasname)
  {
    return childnodes[aliasname];
  }

  void operator[]=(String aliasname,messagevmnode node)
  {
    node.aliasname=aliasname;
    node.aliaspath=aliaspath+'/'+node.aliasname;
    node.vmrouter=this;
    childnodes[aliasname]=node;
    whole_add(node);
  }

  void whole_add(messagevmnode node)
  {
    if (vmrouter!=null)
      vmrouter.whole_add(node);
    else
    {
      wholenodes[node.aliaspath]=node;
    }
  }

  void whole_remove(messagevmnode node)
  {
    if (vmrouter!=null)
      vmrouter.whole_remove(node);
    else
    {
      wholenodes.remove(node.aliaspath);
    }
  }
}
