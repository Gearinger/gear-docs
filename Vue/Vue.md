## 一、生命周期

![实例的生命周期](https://raw.githubusercontent.com/Gearinger/GearSetting/main/picgo/20220627-144304.svg)

## 九、其他

### 1、关于父子组件的加载顺序

在正常开发，挂载周期的执行顺序为：

父beforeCreate => 父created => 父beforeMount => 子beforeCreate => 子created => 子beforeMount => 子mounted => 父mounted

在数据更新阶段执行顺序为：

父beforeUpdate => 子beforeUpdate => 子updated => 父updated

在组件销毁阶段执行顺序为：

父beforeDestroy -> 子beforeDestroy -> 子destroyed -> 父destroyed