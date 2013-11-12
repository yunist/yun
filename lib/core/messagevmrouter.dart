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

abstract class condition_type extends typeenum
{
  static final ct_must_true must_true=const ct_must_true();
  static final ct_maybe_true maybe_true=const ct_maybe_true();
  static final typelist types=new typelist({ct_must_true.symbol:condition_type.must_true
                                            ,ct_maybe_true.symbol:condition_type.maybe_true});
  static final String classpath='/base/typeenum/condition_type';
  static const String symbol='condition.type';
  String get enumname => symbol;
  const condition_type.ctor():super.ctor();

  bool check(bool a,bool b);
}

class ct_must_true extends condition_type
{
  static final String classpath='/base/typeenum/condition_type/ct_must_true';
  static const String symbol='must.true';
  String get typename => symbol ;
  dynamic get toobject => 0x00000001;
  const ct_must_true():super.ctor();
  bool check(bool a,bool b)=>a&&b;
}

class ct_maybe_true extends condition_type
{
  static final String classpath='/base/typeenum/condition_type/ct_maybe_true';
  static const String symbol='maybe.true';
  String get typename => symbol;
  dynamic get toobject => 0x00000002;
  const ct_maybe_true():super.ctor();
  bool check(bool a,bool b)=>a||b;
}


abstract class vmcontext extends base
{
  String get key;
  dynamic getvalue(String keypath);
  void setvalue(String keypath,dynamic value);
  void unset(String keypath);
  static List<String> keys(String keypath)
  {
    return keypath.split('.');
  }
  static String keypath(List<String> keys)
  {
    return keys.join('.');
  }
}

class vm_context extends collection<vmcontext> implements vmcontext
{
  static const String symbol='';
  String get key=>symbol;
  dynamic getvalue(String keypath)
  {
    var keys=vmcontext.keys(keypath);
    if (keys.length>0)
    {
      var key=keys.removeAt(0);
      for (var vm in this)
        if (vm.key==key)
          return vm.getvalue(vmcontext.keypath(keys));
    }
  }
  void setvalue(String keypath,dynamic value)
  {
    var keys=vmcontext.keys(keypath);
    if (keys.length>0)
    {
      var key=keys.removeAt(0);
      for (var vm in this)
        if (vm.key==key)
        {
          vm.setvalue(vmcontext.keypath(keys),value);
          break;
        }
    }
  }
  void unset(String keypath)
  {
    var keys=vmcontext.keys(keypath);
    if (keys.length>0)
    {
      var key=keys.removeAt(0);
      for (var vm in this)
        if (vm.key==key)
        {
          vm.unset(vmcontext.keypath(keys));
          break;
        }
    }
  }
}

class vm_sourcemessage extends vmcontext
{
  static const String symbol='__srcmsg';
  String get key=>symbol;
  dynamic getvalue(String keypath){}
  void setvalue(String keypath,dynamic value){}
  void unset(String keypath){}
}

class vm_targetmessage extends vmcontext
{
  static const String symbol='__trgmsg';
  String get key=>symbol;
  dynamic getvalue(String keypath){}
  void setvalue(String keypath,dynamic value){}
  void unset(String keypath){}
}

class vm_localstatus extends vmcontext
{
  static const String symbol='__lclsts';
  String get key=>symbol;
  dynamic getvalue(String keypath){}
  void setvalue(String keypath,dynamic value){}
  void unset(String keypath){}
}

abstract class vmcondition extends base
{
  bool checkit(vmcontext context);
}

class vc_collection extends dictionary<condition_type,vmcondition> implements vmcondition
{
  bool checkit(vmcontext context)
  {
    bool result=true;
    for (var vcpair in this)
      result=vcpair.key.check(result, vcpair.value.checkit(context));
    return result;
  }
}

class vc_checksourcemessage extends vmcondition
{
  bool checkit(vmcontext context){}
}

class vc_checklocalstatus extends vmcondition
{
  bool checkit(vmcontext context){}
}

abstract class vmexecute extends base
{
  vmcontext doit(vmcontext context);
}

class ve_collection extends collection<vmexecute> implements vmexecute
{
  vmcontext doit(vmcontext context)
  {
    for (var ve in this)
      if ((context=ve.doit(context))==null)
        break;
  }
}

class ve_sendmessage extends vmexecute
{
  vmcontext doit(vmcontext context)
  {

  }
}

class ve_setlocalstatus extends vmexecute
{
  vmcontext doit(vmcontext context)
  {

  }
}

class ve_unsetlocalstatus extends vmexecute
{
  vmcontext doit(vmcontext context)
  {

  }
}

class routervm extends yunvm
{

  Map<String,SendPort> childports={};
  Map<RegExp,Map<vmcondition,vmexecute>> routetable={};
  vmcontext localcontext;

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
    var localmsg=msg;
    if (msg is userdefinedmessage)
    {
      var context=build_vm_context(localcontext);
      routetable.forEach((RegExp msgpattern,Map<vmcondition,vmexecute> conditionmap)
          {
            if (msgpattern.hasMatch(msg.msgid))
            {
              conditionmap.forEach((vmcondition cond,vmexecute exec)
                  {
                    if (cond.checkit(context));
                      context=exec.doit(context);
                  });
              localmsg=null;
            }
          });
      if (context!=null) localcontext=parse_vm_context(context);
    }
    return localmsg;
  }

  vmcontext build_vm_context(vmcontext context)
  {
    return context;
  }

  vmcontext parse_vm_context(vmcontext context)
  {
    return context;
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

class messagenodespool extends dictionary<String,messagevmnode>
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
      var node=wholenodes[msg.aliaspath];
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
