document.addEventListener(
  "turbolinks:load", e => {
    var testCards = ["4242424242424242","4012888888881881","5555555555554444","5105105105105100","3530111333300000","3566002020360505",
                    "378282246310005","371449635398431","38520000023237","30569309025904","6011111111111117","6011000990139424"];
    var card_number = document.getElementById("card_number");
    card_number.addEventListener('focusout', (e) => {
      testCards.some(function(testCard) {
        if(testCard == card_number.value){
          alert("テストカードは使えません。");
          card_number.value = "";
        }
      });
    });

    if (document.getElementById("token_submit") != null) {
      // "token_submit"というidをもつhtmlがあるページか？つまりカード作成ページか
      Payjp.setPublicKey("pk_test_bf8f6b07458f0197ea990312"); 
      let btn = document.getElementById("token_submit");  // 送信ボタンをbtnに格納
      btn.addEventListener("click", e => {  // 送信ボタンがクリックされたとき
        e.preventDefault(); // デフォルトのブラウザの動きをいったんとめる(createアクションへの遷移を)
        let card = {  // cardに入力された値をハッシュで格納
          number: document.getElementById("card_number").value,
          cvc: document.getElementById("cvc").value,
          exp_month: document.getElementById("exp_month").value,
          exp_year: document.getElementById("exp_year").value
        }; 
        Payjp.createToken(card, (status, response) => {
          // カード情報をpayjpに送りカードトークンを(response.id)を受け取る。
          if (status === 200) {  // 正常な値の場合 
            $("#card_number").removeAttr("name");
            $("#cvc").removeAttr("name");
            $("#exp_month").removeAttr("name");
            $("#exp_year").removeAttr("name"); 
            // name属性を削除することにより、dataベースに送るのを防ぐ。
            $("#card_token").append(
              $('<input type="hidden" name="payjp-token">').val(response.id)
              // <input type="hidden" name="payjp-token" value= response.id>が#card_tokenに追加される。
            ); 
            if(!confirm('この内容でよろしかったですか？')){
                /*　キャンセルの時の処理 */
                return false;
            }else{
                /*　OKの時の処理  今回は特に処理がないので空*/
            }
            document.inputForm.submit(); // inputFormのsubmitを発動。（上記で停止していた）
            alert("登録が完了しました"); 
          } else {
            alert("カード情報が正しくありません。");
          }
        });
      });
    }
  },
);