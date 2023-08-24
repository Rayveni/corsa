ELEMENT.locale(ELEMENT.lang.ruRU)

new Vue({
    el: '#app',
	data: {
        backendUrl: "http://127.0.0.1:8000",
        loading: false,
        loginError: false,
        form: {
            username: '',
            password: ''
        },
        rules: {
            username: [{ required: true, message: 'Поле username - обязательное', trigger: 'blur' }],
            password: [{ required: true, message: 'Поле password - обязательное', trigger: 'blur' }]
        }
    },
    methods: {
        onSubmit: function(formName) {
            this.$refs[formName].validate((valid) => {
                if (valid) {
                    var bodyFormData = new FormData();
                    bodyFormData.append('username', this.form.username);
                    bodyFormData.append('password', this.form.password);

                    this.loading = true;

                    axios({
                            method: "post",
                            url: this.backendUrl + '/login/',
                            data: bodyFormData,
                            headers: { "Content-Type": "multipart/form-data" },
                        })
                        .then((response) => {
                            localStorage.setItem('userId', response.data.id)
                            localStorage.setItem('userName', response.data.name);
                            localStorage.setItem('userToken', response.data.token);
                            this.loading = false;

                            window.location.replace('/index.html');
                        })
                        .catch((response) => {
                            this.loginError = true;
                            this.loading = false;
                        });
                } else {
                    return false;
                }
            });
        }
    },
    mounted: function() {
    }
});
