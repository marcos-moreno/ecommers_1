<template>
  <v-main>
    <app-menu/>
    <div v-if="isLoad==false">
      <div class="text-center">
        <v-dialog v-model="isLoad" persistent width="300">
          <v-card color="primary" dark >
            <v-card-text>
              cargando
              <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
            </v-card-text>
          </v-card> 
        </v-dialog>
      </div> 
      <div v-if="!isLoad"> 
        <v-container v-if="msgerror!=''" class="my-6 grey lighten-5"  >
          <v-alert  dense  outlined  type="error" > 
            {{ msgerror }}
          </v-alert>
        </v-container>

      <div v-if="isChangePassword ==false">
        <v-container v-if="existeUsuario==false" class="my-6 grey lighten-5"  >
          <v-card  height="500" width="500"  class="mx-auto"> 
            <v-container fill-height fluid> 
              <v-row align="center" justify="center"> 
                <v-card-title>¡Hola! Ingresa tu teléfono, e‑mail o usuario</v-card-title>
                  <v-container style="width:90%" class="my-10 mx-auto">
                    <v-text-field  @keyup.enter.native="comprobarUsuario" v-model="user" 
                    label="Teléfono, e-mail o usuario" filled rounded dense ></v-text-field>
                  </v-container> 
                  <v-btn class="my-5 mx-auto" width="80%" large color="primary" @click="comprobarUsuario" >
                    Continuar
                  </v-btn> 
              </v-row>
            </v-container>
          </v-card> 
        </v-container>

        <v-container v-else class="my-6 grey lighten-5"  >
          <v-card height="500" width="500"  class="mx-auto"> 
            <v-btn @click="returnUser()" text color="primary" class="my-2" >
              <v-icon dark left >mdi-arrow-left </v-icon>
              <span>Regresar</span> 
            </v-btn>

            <v-container v-if="existeUsuario==true" fill-height fluid> 
              <v-row align="center" justify="center"> 
                <v-card-title>¡Muy bien! Ahora Ingresa tu contraseña</v-card-title>
                <v-container style="width:90%" class="my-2 mx-auto"> 
                  <v-text-field name="user" prepend-icon="mdi-account" v-model="user" disabled
                  ></v-text-field> 
                </v-container>
                <v-container style="width:90%" class="my-2 mx-auto">
                  <v-text-field @keyup.enter.native="login" :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                      :type="showPass ? 'text' : 'password'" label="Contraseña"
                      @click:append="showPassw" v-model="password"
                  ></v-text-field> 
                </v-container>
                <v-btn class="my-5 mx-auto" width="80%" large color="primary" @click="login" >
                  Continuar
                </v-btn> 
              </v-row>
            </v-container> 
          </v-card>
        </v-container>
      </div>
<!--   -->
        <v-container v-if="isChangePassword"   class="my-6 grey lighten-5"  >
          <!--  height="500"  -->
          <v-card width="500"  class="mx-auto"> 
            <v-btn @click="returnUser()" text color="primary" class="my-2" >
              <v-icon dark left >mdi-arrow-left </v-icon>
              <span>Regresar</span> 
            </v-btn>  

            <v-container v-if="codeValid==false" fill-height fluid>  
               <v-row align="center" justify="center"> 
                  <v-card-title>Código de seguridad</v-card-title>
                  <v-card-subtitle>Para continuar ingresa el código de seguridad que te hicimos llegar a tu correo electrónico</v-card-subtitle>
                  <v-container style="width:90%" class="my-10 mx-auto">
                    <v-text-field  type="number"  class="centered-input text--darken-3 mt-3" 
                     @keyup.enter.native="comprobarCodigo" v-model="codeSecurity" 
                      label="Código de seguridad" filled rounded dense 
                      onkeydown="javascript: return event.keyCode == 69 ? false : true"
                    ></v-text-field>
                  </v-container>
                  <v-btn :disabled="codeSecurity.length != 6" class="my-5 mx-auto" width="80%" large color="primary" @click="comprobarCodigo" >
                    Continuar
                  </v-btn> 
              </v-row>
            </v-container> 
 
            <v-container v-if="codeValid"  fill-height fluid>  
               <v-row align="center" justify="center"> 
                  <v-card-title>¡Excelente!, ahora Ingresa tu nueva contraseña</v-card-title> 
                  <v-container style="width:90%" class="my-10 mx-auto">
                    
                  <v-container style="width:90%" class="my-2 mx-auto">
                    <v-text-field :append-icon="showPasswC1 ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="showPasswC1 ? 'text' : 'password'" label="Contraseña" v-model="password1"
                        @click:append="showPasswC1 == true ? showPasswC1 = false : showPasswC1 = true;"
                        onkeydown="javascript: return event.keyCode == 32 ? false : true"
                    ></v-text-field> 
                  </v-container>

                  <v-container style="width:90%" class="my-2 mx-auto">
                    <v-text-field :append-icon="showPasswC2 ? 'mdi-eye' : 'mdi-eye-off'"
                        :type="showPasswC2 ? 'text' : 'password'" label="Repite tu contraseña"
                        @click:append="showPasswC2 == true ? showPasswC2 = false : showPasswC2 = true;"
                        v-model="password2"
                        onkeydown="javascript: return event.keyCode == 32 ? false : true"
                    ></v-text-field> 
                  </v-container>

                  </v-container>
                  <v-btn class="my-5 mx-auto" width="80%" 
                    large color="primary" @click="comprobarPasswords" >
                    Cambiar Contraseña
                  </v-btn> 
              </v-row>
            </v-container> 

          </v-card>
        </v-container> 

      </div>
    </div>
  </v-main> 
</template>

<style lang="scss">
    input[type=number]::-webkit-inner-spin-button, 
    input[type=number]::-webkit-outer-spin-button { 
    -webkit-appearance: none; 
    margin: 0; 
    }

    input[type=number] { -moz-appearance:textfield; }
</style>

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'
  import AppMenu from '../components/Menu.vue';

  export default {
    name:"login", 
    data() {
      return {  
        isLoad : false,
        user:"",
        password:"",
        existeUsuario : false,
        showPass :false, 
        msgerror : "",
        isChangePassword:false,
        codeSecurity:"",
        codeValid:"",
        passwordValidos:false,
        showPasswC1 :false, 
        showPasswC2 :false, 
        password1:"",
        password2:"",
        tokenTemporal : ""
      }
    }, components: { 
      'app-menu': AppMenu, 
    },
    methods:{
      async comprobarPasswords(){
        if (this.password1.toUpperCase() == "REFIVIDRIO") {
          this.msgerror = "No puedes usar esta contraseña";
          return false;
        }
        if (this.password1 === this.password2) {
          if (this.password1.length < 8) {
            this.msgerror = "La contraseña debé contener mínimo 8 caracteres"; 
            return false;
          }
        }else{
          this.msgerror = "Las contraseñas no coinciden";
          return false;
        }
        this.msgerror = "";
        this.isLoad = true; 
        let resuser = await axios.put(
          config.apiAdempiere + "/user/changePasswordUser"
          ,{password:this.password1,isActivate:true}
          ,{headers:{'token': this.tokenTemporal}})
        .then(function (response){ 
          return response.data;
        })
        .catch(function (response){
          console.log(response);
          return false;
        }); 
        if (resuser==false) {
          this.msgerror = "Ocurrio un error, intentalo más tarde.";
        } else {
          if (resuser.status == "success") {
             this.msgerror = "";
             alert("Cambio de contraseña correcto, es necesario reiniciar tu sesión.");
             this.returnUser();
          }else{
             this.msgerror = "Ocurrio un error, contraseña no actualizada.";
          }
        } 
        this.isLoad = false;
      },
      async comprobarCodigo(){
        this.isLoad =true; 
        let resuser = await axios.get(config.apiAdempiere + "/user/validCodSeg"
          ,{headers: { 'token': this.tokenTemporal }
          ,params: {code:this.codeSecurity}} 
        ).then(function (response){return response; })
        .catch(function (response){console.log(response);return false;});
        this.codeValid = false;
        if (!resuser) {
          this.msgerror = "Ocurrio un error, intenta recargar esta página";
        }else{
          if (resuser.data.status == "success" && resuser.data.data == true){
            this.msgerror = "";
            this.codeValid = true;
          } else {
            this.msgerror = "El código de seguridad es incorrecto";
          }
        }
        this.isLoad =false;  
      },
      returnUser(){
        this.existeUsuario = false;
        this.codeValid = false;
        this.isChangePassword = false;
        this.tokenTemporal = "";
        this.user = "";
        this.password = "";
        this.isChangePassword=false,
        this.codeSecurity= "";
        this.codeValid= "";
        this.passwordValidos= false;
        this.showPasswC1= false;
        this.showPasswC2= false;
        this.password1= "";
        this.password2= "";
      },
      showPassw(){ 
        this.showPass == true ? this.showPass = false : this.showPass = true;
      },
      async comprobarUsuario(){ 
        if (this.user.length < 2) {
          this.msgerror = "Por favor ingresa tu usuario."
        }else{
          this.msgerror = ""
          this.existeUsuario = await axios.get(config.apiAdempiere + "/user/exist",{params: {value:this.user}})
                              .then(function (response) 
          { 
            if (response.data.status == "success") {
              if (response.data.data[0].result =="true" || response.data.data[0].result ==true) {
                return true;
              } else {
                return false;
              } 
            }else{
              console.log(response.data.data);
              return false;
            }
          }).catch(function (response){console.log(response);return [];}); 
          this.existeUsuario == false ? this.msgerror = "El usuario No existe" : this.msgerror = "";
        }
      },
      
      async login(){ 
        if (this.password.length < 2) {
          this.msgerror = "Por favor ingrese su contraseña."
        }else{
          try {
            this.msgerror = ""
            let resuser = await axios.post(config.apiAdempiere + "/user/login",{user:this.user,password:this.password })
            .then(function (response){ 
              return response;
            })
            .catch(function (response){
              console.log(response);
              return {status:"error",token:null,user:{"value":""}};
            });

            if (resuser.data.status == "success") { 
              if (resuser.data.user.requires_password_change) {
                this.isChangePassword = true;
                this.tokenTemporal = resuser.data.token; 
              }else{ 
                this.isChangePassword = false;
                this.msgerror = "";
                this.$cookie.set('token',resuser.data.token);  
                this.$cookie.set('isLogged','true');  
                location.href = "/";
              }
            }else{
              this.msgerror = "La contraseña es incorrecta";
            }
          } catch (error) {
            this.msgerror = "Existe un error, Intentalo más tarde.";
          } 
        }
      }
      ,getRandomInt() {
        return Math.floor(Math.random() * (9 - 0)) + 0;
      },
    },  
    async mounted() {
      window.scrollTo(0,0); 
    }, 
    async created(){ 
        this.isLoad =true;
        let userObj = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        })
        .then(res=>{return res.data;})
        .catch(err=>{return err;}); 
        console.log(userObj);   
        if (userObj.status == "success") {
          this.$router.push('/shop/Account');
        }else{
          let inputCar = document.getElementById("cantidadInCar");
          if (inputCar != null) {
            inputCar.value = "";
          }
        }
        this.isLoad =false;
    }
  }
</script>