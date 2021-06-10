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
      </div> 
        <v-container v-if="isChangePassword"   class="my-6 grey lighten-5"  > 
          <v-card width="500"  class="mx-auto"> 
            <v-btn @click="returnUser()" text color="primary" class="my-2" >
              <v-icon dark left >mdi-arrow-left </v-icon>
              <span>Regresar</span> 
            </v-btn>   
            <v-container v-if="passworActuaCorrecto==false" fill-height fluid>  
               <v-row align="center" justify="center"> 
                  <v-card-title>Cambio de contraseña</v-card-title>
                  <v-card-subtitle>Para continuar ingresa tu contraseña actual</v-card-subtitle>
                    <v-container style="width:90%" class="my-2 mx-auto">
                        <v-text-field @keyup.enter.native="login" :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                            :type="showPass ? 'text' : 'password'" label="Contraseña"
                            @click:append="showPassw" v-model="password"
                        ></v-text-field> 
                    </v-container> 
                  <v-btn :disabled="!(password.length > 7)" 
                    class="my-5 mx-auto" width="80%" 
                    large color="primary" @click="comprobarPasswordActual" >
                    Continuar
                  </v-btn> 
              </v-row>
            </v-container>  
            <v-container v-if="passworActuaCorrecto"  fill-height fluid>  
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
        password:"",
        passworActuaCorrecto : false,
        showPass :false, 
        msgerror : "",
        passwordValidos:false,
        showPasswC1 :false, 
        showPasswC2 :false, 
        password1:"",
        password2:"",
      }
    }, components: { 
      'app-menu': AppMenu, 
    },
    methods:{
        async comprobarPasswordActual(){
            let resuserPassword = await axios.post(config.apiAdempiere + "/user/comprobarPasswordActual"
            ,{password:this.password}
            ,{headers:{ 'token': this.$cookie.get('token') }})
            .then(function (response){return response; })
            .catch(function (response){console.log(response);return false;});
            console.log(resuserPassword);
            if (resuserPassword==false) {
                this.msgerror = "Ocurrio un error, intentalo más tarde.";
            } else {
                if (resuserPassword.data.status == "success" && resuserPassword.data.data) {
                    this.passworActuaCorrecto = true;
                    this.msgerror = "";
                }else{
                    this.msgerror = "Ocurrio un error, la contraseña no es correta.";
                }
            } 
        },
        async comprobarPasswords(){
            if (this.password1.toUpperCase() == "REFIVIDRIO") {
                this.msgerror = "No puedes usar esta contraseña";
                return false;
            }
            if (this.password1 === this.password2) {
                if (this.password1.length < 8) {
                    this.msgerror = "La contraseña debé contener mínimo 8 caracteres"; 
                    return false;
                }else{
                     if (this.password1.toUpperCase() == this.password.toUpperCase()) {
                        this.msgerror = "No puedes usar la misma contraseña";
                        return false;
                    }
                }
            }else{
                this.msgerror = "Las contraseñas no coinciden";
                return false;
            }
            this.msgerror = "";
            this.isLoad = true; 
            let resuser = await axios.put(
                config.apiAdempiere + "/user/changePasswordUser"
                ,{password:this.password1,isActivate:false}
                ,{headers:{'token': this.$cookie.get('token')}}
            ).then(function (response){ 
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
                    this.$router.push('/shop/Logout');
                }else{
                    this.msgerror = "Ocurrio un error, contraseña no actualizada.";
                }
            } 
            this.isLoad = false;
      }, 
      showPassw(){
        this.showPass == true ? this.showPass = false : this.showPass = true;
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
        if (userObj.status != "success") { 
          let inputCar = document.getElementById("cantidadInCar");
          if (inputCar != null) {
            inputCar.value = "";
          }
        }
        this.isLoad =false;
    }
  }
</script>