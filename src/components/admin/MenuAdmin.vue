<template> 
  <div>
  <v-app-bar color="deep" dark> 
        <v-app-bar-nav-icon @click="drawer = true"></v-app-bar-nav-icon> 
        <v-toolbar-title>Refividrio Admin</v-toolbar-title> 
        <v-spacer></v-spacer>     
        <v-toolbar-title v-if="isLogged" > 
          <div class="text-center">
            <v-menu v-model="menuAccount" :close-on-content-click="false" :nudge-width="200" offset-x>
              <template v-slot:activator="{ on, attrs }"> 
                  <v-avatar color="#004DA9">
                    <span v-bind="attrs"  v-on="on"  class="white--text headline">{{letterAvatar}}</span>
                  </v-avatar>
              </template>  
              <v-card>
                <v-list>
                  <v-list-item>
                    <v-avatar color="#004DA9">
                      <span   class="white--text headline">{{letterAvatar}}</span>
                    </v-avatar> 
                    <v-list-item-action>   
                      <v-list-item-subtitle>{{user.user}}</v-list-item-subtitle> 
                    </v-list-item-action>
                  </v-list-item>
                </v-list> 
                <v-divider></v-divider>  
                <v-row justify="center">
                  <v-col>
                    <v-card>
                      <v-card-text> 
                          {{user.user}} 
                      </v-card-text> 
                    </v-card>
                  </v-col>  
                </v-row>  
                <v-list-item-group v-model="group"> 
                <v-list-item @click="logout()">
                  <v-list-item-icon>
                    <v-icon>mdi-logout</v-icon>
                  </v-list-item-icon>
                  <v-list-item-title>Salir</v-list-item-title>
                </v-list-item> 
              </v-list-item-group> 
              </v-card>
            </v-menu>
          </div> 
          <!-- {{user}} -->
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
              </v-menu>
            </div> 
        </v-toolbar-title>  
      </v-app-bar>  
      <v-navigation-drawer v-model="drawer" absolute temporary>
        <v-list nav dense >
          <v-list-item-group>
            Refividrio 
              <v-list-item-group v-model="group"> 
              <v-list-item @click="menu('HomeAdmin')" >
                <v-list-item-icon  >
                  <v-icon>mdi-home</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Inicio</v-list-item-title>
              </v-list-item> 
              <v-list-item @click="menu('ForumAdmin')" >
                <v-list-item-icon>
                  <v-icon>mdi-comment-text-outline</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Preguntas</v-list-item-title>
              </v-list-item>
               <v-list-item @click="menu('ComplaintsSuggestionsAdmin')">
                <v-list-item-icon>
                  <v-icon>mdi-clipboard-edit-outline</v-icon>
                </v-list-item-icon>
                <v-list-item-title>Quejas y Sugerencias</v-list-item-title>
              </v-list-item>             
            </v-list-item-group>
          </v-list-item-group> 
        </v-list>
      </v-navigation-drawer> 
 
  </div> 
</template>

<script> 
  import axios from 'axios'; 
  import config from '../../json/config.json'; 

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
      logout(){
        this.$router.push('/shop/Logout');
      } , 
      menu(name){
         let path =name;// config.matchAdmin+'/'+name;
        if (this.$route.path !== path &&
          this.$route.path !== 
          ((path.charAt(path.length-1) == '/')?path.substring(0,(path.length-1)):path +'/')
        ){
          this.$router.push(path);
        } 
        this.menuAccount = false;
        this.menuNoAccount = false;
      },async validaLogin(){
          this.user = await axios.get(config.apiAdempiere + "/user/userByTokenAdmin", 
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
      }
    },
    async created(){  
      this.validaLogin();
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