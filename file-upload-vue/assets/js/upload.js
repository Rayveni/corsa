ELEMENT.locale(ELEMENT.lang.ruRU);

function spinner_state(state) {
  document.querySelector('#loader').hidden = state;
  document.querySelector('#upload-container').hidden = !state;
};

function message_update(success,message) {
  document.querySelector('#message_id').textContent = message;

};

spinner_state(true);
new Vue({
  el: '#app',
  data: {
    backendUrl: 'http://127.0.0.1:5001/upload',
    form: {
      username: '',
      report: '',
      checked: true,
      selected: 'Other'
    },
    rules: {
      username: [
        {
          required: true,
          message: 'Поле username - обязательное',
          trigger: 'blur',
        },
      ],
      report: [
        {
          required: true,
          message: 'Поле Отчёт - обязательное',
          trigger: 'blur',
        },
      ],
    },
  },
  methods: {
    handleFileUpload(event) {
      this.file = event.target.files[0];
    },

    onSubmit: function (formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          let formData = new FormData();
          formData.append('file', this.file);

          formData.append(
            'report_params',
            JSON.stringify({
              user: this.form.username,
              report: this.form.report,
              load_mode: this.form.selected,
              auto_extrapolation: this.form.checked,
            })
          );
          spinner_state(false);
          axios({
            method: 'post',
            url: this.backendUrl,
            data: formData,
            headers: { 'Content-Type': 'multipart/form-data' },
          })
            .then((response) => {
              spinner_state(true);
              message_update(response['data']['status'], response['data']['message'])
    
          
    
            })
            .catch((response) => {

              spinner_state(true);
              message_update(false,'error')
              console.log(response);
            });
        } else {
          return false;
        }
      });
    },
  },
  mounted: function () {},
});
