var aBool = true;
var aStr = '我爱你中国';
var aDic = {"age": 10}

function sum(num1, num2) {
    return num1 + num2;
}

//js没有重载的概念下面的会覆盖上面的函数
function sum(num1, num2, num3) {
    return num1 + num2 + num3;
}

function kaiTestSum(num1, num2, num3) {
    console.kaiNewFun(`lookKai log in js: kaiTestSum n1=${num1} n2=${num2} n3=${num3}`);
    return num1 + num2 + num3;
}

function kaiTestReturnMap(num1, num2, num3) {
    console.log('lookKai log in js: kaiTestReturnMap n1=${num1} n2=${num2} n3=${num3}');
    return {num1, num2, num3};
}