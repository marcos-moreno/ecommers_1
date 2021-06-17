<template> 
  <div>
  <v-app-bar color="deep" dark> 
        <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon> 
        <v-toolbar-title>Refividrio</v-toolbar-title> 
        <v-spacer></v-spacer> 

        <v-toolbar-title> 
          <a style="color:#fff;" @click="menu('/shop/Foro')">
            <!-- <v-icon style="margin:5px"  >mdi-account-group-outline</v-icon> -->
            Foro
          </a>
        </v-toolbar-title>

        <v-toolbar-title>
          <v-btn @click="shopincaropen()" class="ma-2" text  color="#FFF"  >
            <v-icon>mdi-cart</v-icon>
            <div v-if="isLogged"> 
              <input disabled style="color:#fff;border:none;width:20px;" id="cantidadInCar"/>
              </div>
          </v-btn>
        </v-toolbar-title>
        <v-toolbar-title v-if="isLogged" > 
          <div class="text-center">
            <v-menu v-model="menuAccount" :close-on-content-click="false" :nudge-width="200" offset-x>
              <template v-slot:activator="{ on, attrs }"> 
                  <v-avatar color="red">
                    <span v-bind="attrs"  v-on="on"  class="white--text headline">{{letterAvatar}}</span>
                  </v-avatar>
              </template>  
              <v-card>
                <v-list>
                  <v-list-item>
                    <v-avatar color="red">
                      <span   class="white--text headline">{{letterAvatar}}</span>
                    </v-avatar> 
                    <v-list-item-action>   
                      <v-list-item-subtitle>{{user.username}}</v-list-item-subtitle> 
                    </v-list-item-action>
                  </v-list-item>
                </v-list> 
                <v-divider></v-divider>  
                <v-row justify="center">
                  <v-col>
                    <v-card>
                      <v-card-text> 
                          {{user.email}} 
                      </v-card-text> 
                    </v-card>
                  </v-col>  
                </v-row>  
                <v-list-item-group v-model="group">
                <v-list-item @click="menu('/shop/purchases')">
                  <v-list-item-icon  >
                    <v-icon>mdi-shopping</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Mis Compras</v-list-item-title>
                </v-list-item>

                <v-list-item @click="menu('/shop/Account')">
                  <v-list-item-icon>
                    <v-icon>mdi-account</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Mis datos</v-list-item-title>
                </v-list-item>

                <v-list-item @click="menu('/shop/ChangePassword')">
                  <v-list-item-icon>
                    <v-icon>mdi-lock</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Cambiar Contraseña</v-list-item-title>
                </v-list-item>

                <v-list-item @click="menu('/shop/Logout')">
                  <v-list-item-icon>
                    <v-icon>mdi-logout</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Salir</v-list-item-title>
                </v-list-item> 
              </v-list-item-group> 
              </v-card>
            </v-menu>
          </div> 
        </v-toolbar-title> 

        <v-toolbar-title v-else > 
            <div class="text-center">
              <v-menu v-model="menuNoAccount" :close-on-content-click="false" :nudge-width="200" offset-x>
                <template v-slot:activator="{ on, attrs }"> 
                    <v-avatar color="#8A8A8A">
                      <span v-bind="attrs"  v-on="on">
                        <v-icon>mdi-account</v-icon>
                      </span> 
                    </v-avatar>
                </template>  
                <v-card>  
                  <v-list-item @click="menu('/shop/Login')">
                    <v-list-item-icon>
                      <v-icon>mdi-account</v-icon>
                    </v-list-item-icon>
                    <v-list-item-title>Iniciar Sesión</v-list-item-title>
                  </v-list-item> 

                  <v-list-item @click="menu('/shop/register')">
                    <v-list-item-icon>
                      <v-icon>mdi-pencil</v-icon>
                    </v-list-item-icon>
                    <v-list-item-title>PRE-REGISTRO</v-list-item-title>
                  </v-list-item> 
                  
                </v-card>
              </v-menu>
            </div> 
        </v-toolbar-title>  
      </v-app-bar> 


      <v-navigation-drawer v-model="drawer" absolute temporary>
        <v-list nav dense >
          <v-list-item-group>
            Refividrio 
              <v-list-item-group v-model="group"> 
              <v-list-item @click="menu('/shop/Home')">
                <v-list-item-icon  >
                  <v-icon>mdi-home</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Inicio</v-list-item-title>
              </v-list-item> 
              <v-list-item @click="menu('/shop/Login')">
                <v-list-item-icon>
                  <v-icon>mdi-account</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Cuenta</v-list-item-title>
              </v-list-item>

              <v-list-item @click="menu('/shop/Foro')">
                <v-list-item-icon>
                  <v-icon>mdi-account-group-outline</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Foro</v-list-item-title>
              </v-list-item>

            </v-list-item-group>
          </v-list-item-group> 
        </v-list>
      </v-navigation-drawer> 
 
  </div> 
</template>

<script> 
  import axios from 'axios'; 
  import config from '../json/config.json'; 

  export default {
    data: () => ({
      isLogged : false,
      user:{userpin:"N"},   
      drawer: false,
      group: null, 
      fav: true,
      menuAccount: false,
      menuNoAccount: false,
      message: false,
      hints: true,
      shopingcar:[], 
    }),
    components: {
    },
    methods:{ 
      shopincaropen(){ 
        if (this.isLogged) {
          this.menu('/shop/shopingcar/'); 
        } else {
          this.menu('/shop/Login/');  
        }
      },
      menu(path){ 
        if (path == '/shop/Home') {
          location.href = "/shop/Home";
        }
        if (this.$route.path !== path &&
          this.$route.path !== 
          ((path.charAt(path.length-1) == '/')?path.substring(0,(path.length-1)):path +'/')
        ){
          this.$router.push(path);
        } 
        this.menuAccount = false;
        this.menuNoAccount = false;
      },async validaLogin(){
        if (!this.isLogged)return; 
        this.shopingcar = await axios.get(config.apiAdempiere + "/shopingcar/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (this.shopingcar.status == "success") {
          this.shopingcar = this.shopingcar.data;
          document.getElementById("cantidadInCar").value = this.shopingcar.length==0?"":this.shopingcar.length;
        }else if(this.user.status == "unauthorized"){
          this.shopingcar = [];
        }  
      }
    },
    async created(){  
      this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
      {
        'headers': { 'token': this.$cookie.get('token') }
      }).then(res=>{return res.data;})
      .catch(err=>{return err;});
      if (this.user.status == "success") {
        this.user = this.user.user;
        this.isLogged = true; 
      }else if(this.user.status == "unauthorized"){ 
        this.isLogged = false;
      }
      this.validaLogin() 
    },
    async mounted(){ 
    },
    computed:{
      letterAvatar(){
        return this.user.username.substring(1,0).toUpperCase();
      },
      shopingcarlength(){ 
        return this.shopingcar.length;
      },
    } 
  }
</script>