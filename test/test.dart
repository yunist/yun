
import "dart:core";
import "../lib/servicebus/base.dart";
import "../lib/core/base.dart";

main()
{
  var t=new Stopwatch();
  print("hello");
  t.start();
  print(bus_type.types['stack'].typename);
  print(bus_type.types['queue'].runtimeType.toString());
  var x=new routervm(null,null,null,null);
  var y=[];
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  y.add(new ct_maybe_true());
  t.stop();
  print(t.elapsedTicks);
}