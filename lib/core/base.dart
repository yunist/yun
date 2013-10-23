// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/**
 * all base classes of the yun framework. and a top-level function to create instance by name
 *
 */

library yun;

import "dart:isolate";
import "dart:mirrors";
import "package:js/js.dart" as js;
//import "package:json/json.dart" as json;

part "message.dart";
part "service.dart";
part "messagevmrouter.dart";
part "messagevmnode.dart";
part "isolatepool.dart";
part "systembuilder.dart";

/// root route table
List rootrouters=[];

/// main receive port
ReceivePort receiveport;

/**
 * a base class of yun.
 */
class base
{
  static final String classpath='/base';
  const base.ctor();
  base();
}

/**
 * a data class. should to implement serialization using mirrorsystem
 */
class data extends base
{
  static final String classpath='/base/data';
  const data.ctor():super.ctor();
  data();
}

/**
 * repleace list to inherit from yun base
 */
class collection extends data
{
  static final String classpath='/base/data/collection';
  List items;
  dynamic remove_first()
  {
    return items.removeAt(0);
  }
  dynamic remove_last()
  {
    return items.removeLast();
  }
  void add_last(dynamic item)
  {
    items.add(item);
  }
}

/**
 * repleace map to inherit from yun base
 */
class dictionary<T> extends data
{
  static final String classpath='/base/data/dictionary<T>';
  Map<T,dynamic> items;

  dynamic operator[](T key)
  {
    return items[key];
  }

  void operator[]=(T key,dynamic value)
  {
    return items[key]=value;
  }

  dynamic remove(T key)
  {
    return items.remove(key);
  }
}

/**
 * queue
 */
class queue extends collection
{
  static final String classpath='/base/data/collection/queue';
  dynamic dequeue()
  {
    return remove_first();
  }
  void enqueue(dynamic item)
  {
    add_last(item);
  }
}

/**
 * stack
 */
class stack extends collection
{
  static final String classpath='/base/data/collection/stack';
  dynamic pop()
  {
    return remove_last();
  }
  void push(dynamic item)
  {
    add_last(item);
  }
}

/**
 * class-based enumerated type
 */
abstract class typeenum extends data
{
  static final String classpath='/base/data/collection/typeenum';
  String get typename;
  String get enumname;
  const typeenum.ctor():super.ctor();
}

/**
 * top-level function to create instance from class name
 */
dynamic CreateInstance(Symbol libraryname,Symbol classname,List arguments)
{
  MirrorSystem mirrors = currentMirrorSystem();
  dynamic lf = mirrors.findLibrary(libraryname);
  if (lf!=null)
    lf.forEach((LibraryMirror lm)
    {
      ClassMirror cm = lm.classes[classname];
      if (cm!=null)
      {
        InstanceMirror im = cm.newInstance(const Symbol(''), arguments);
        return im.reflectee;
      }
    });
  return null;
}