$(document).on("ready turbolinks:load", function() {
  $("#questionButton").on("click" ,function(){
    let question1Prop = $("#question1").prop("checked");
    let question2Prop = $("#question2").prop("checked");
    let question3Prop = $("#question3").prop("checked");
    let question4Prop = $("#question4").prop("checked");
    if(question1Prop){
      $("#firstForm").hide();
      $("#form1").fadeIn();
    }
    if(question2Prop){
      $("#firstForm").hide();
      $("#form2").fadeIn();
    }
    if(question3Prop){
      $("#form3").fadeIn();
      $("#firstForm").hide();
    }
    if(question4Prop){
      $("#form4").fadeIn();
      $("#firstForm").hide();
    }
  });

  $("#submit1").click(function() {
    let answer1Prop = $("#answer1").prop('checked');
    let answer2Prop = $("#answer2").prop('checked');
    let answer3Prop = $("#answer3").prop('checked');
    let answer4Prop = $("#answer4").prop('checked');

    if(answer1Prop){
      $("#form1").attr('action',$("#answer1").data('action'));
    }
    if(answer2Prop){
      $("#form1").attr('action',$("#answer2").data('action'));
    }
    if(answer3Prop){
      $("#form1").attr('action',$("#answer3").data('action'));
    }
    if(answer4Prop){
      $("#form1").attr('action',$("#answer4").data('action'));
    }
  });

  $("#submit2").click(function() {
    let answer5Prop = $("#answer5").prop('checked');
    let answer6Prop = $("#answer6").prop('checked');
    let answer7Prop = $("#answer7").prop('checked');
    let answer8Prop = $("#answer8").prop('checked');

    if(answer5Prop){
      $("#form2").attr('action',$("#answer5").data('action'));
    }
    if(answer6Prop){
      $("#form2").attr('action',$("#answer6").data('action'));
    }
    if(answer7Prop){
      $("#form2").attr('action',$("#answer7").data('action'));
    }
    if(answer8Prop){
      $("#form2").attr('action',$("#answer8").data('action'));
    }
  });

  $("#questionButton").click(function(){
    const startTime = Date.now(); // 回答開始時間
    $("#form3submit").click(function(){
      const endTime = Date.now(); // 回答終了時間
      let time = endTime - startTime;
      let time2 = time/1000;
      let time3 = Math.round(time2 * 10) / 10 //小数点第二位以下は切り捨て
      $("#form3").hide();
      $("#form3_answer").fadeIn();
      let form3inputVal = $("#form3input").val();
      $("#answerText").text(form3inputVal); //回答内容を貼り付け
      $("#answerTime").text(time3); //回答時間を貼り付け
    });
  });
});