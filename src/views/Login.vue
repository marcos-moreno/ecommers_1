<template>
  <v-main>
    <v-container v-if="msgerror!=''" class="my-6 grey lighten-5"  >
      <v-alert  dense  outlined  type="error" > 
        {{ msgerror }}
      </v-alert>
    </v-container>

    <v-container v-if="existeUsuario==false" class="my-6 grey lighten-5"  >
      <v-card  height="500" width="500"  class="mx-auto"> 
        <v-container fill-height fluid> 
          <v-row align="center" justify="center"> 
            <v-card-title>¡Hola! Ingresa tu teléfono, e‑mail o usuario</v-card-title>
               <v-container style="width:90%" class="my-10 mx-auto">
                 <v-text-field @keyup.enter.native="comprobarUsuario" v-model="user" label="Teléfono, e-mail o usuario" filled rounded dense ></v-text-field>
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
        <v-btn @click="returnUser" text color="primary" class="my-2" >
          <v-icon dark left >mdi-arrow-left </v-icon>
          <span>Regresar</span> 
        </v-btn>

        <v-container v-if="existeUsuario==true" fill-height fluid> 
          <v-row align="center" justify="center"> 
            <v-card-title>¡Muy bien! Ahora Ingresa tu contraseña</v-card-title>
              <v-container style="width:90%" class="my-10 mx-auto">
                <v-text-field @keyup.enter.native="login" :append-icon="showPass ? 'mdi-eye' : 'mdi-eye-off'"
                    :type="showPass ? 'text' : 'password'" label="Password"
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
  </v-main> 
</template>

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'
  export default {
    name:"login",
    // props: ['value'], 
    data() {
      return {  
        user:"",
        password:"",
        existeUsuario : false,
        showPass :false, 
        msgerror : ""
      }
    },
    methods:{
      returnUser(){
        this.existeUsuario = false;
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
          this.msgerror = ""
          let resuser = await axios.post(config.apiAdempiere + "/user/login",{user:this.user,password:this.password })
          .then(function (response){ 
            return response;
          })
          .catch(function (response){
            console.log(response);
            return {status:"error",token:null,user:{"value":""}};
          }); 
          if (resuser.data.status == "success" && resuser.data.token != undefined) { 
            this.msgerror = ""; 
            this.$cookie.set('token',resuser.data.token);  
            this.$cookie.set('isLogged','true');  
            location.href = "/";
          }else{
            this.msgerror = "La contraseña es incorrecta";
          } 
        }
      }
    },  
    async mounted() {    
      window.scrollTo(0,0);
    },
    async created(){ 
        let userObj = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        })
        .then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (userObj.status == "success") {
          this.$router.push('/shop/Account');
        }  
    }
  }
</script>