<template>
  <v-main>
    <app-menu/>
    <v-container class="my-6"> 
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
        <div v-if="isLoad==false">
          <v-row justify="center">
            <div>Datos de cuenta</div> 
          </v-row>  
          <v-row justify="center">
            <v-col cols="12" sm="10" md="8" lg="6" >
              <v-card ref="form"> 
                <v-card-text> 
                  <!-- <v-text-field ref="name" v-model="user.username" label="Nombre" required></v-text-field>
                  <v-text-field ref="name" v-model="user.phone2" label="Celular" required></v-text-field>
                  <v-text-field ref="name" v-model="user.value" label="No. Cliente" required></v-text-field>
                  <v-text-field ref="name" :value="formatMXN(user.so_creditlimit) + ' MXN'" 
                   label="Limite de Crédito" required></v-text-field>
                  <v-text-field  ref="name" :value="formatMXN(user.so_creditused) + ' MXN'" label="Crédito Usado" required></v-text-field> -->
                  
                  <v-card-text> Nombre <br>{{user.username}}</v-card-text>
                  <v-divider></v-divider>
                  <v-card-text> Celular <br>{{user.phone2}}</v-card-text>
                  <v-divider></v-divider>
                  <v-card-text> No. Cliente <br>{{user.value}}</v-card-text>
                  <v-divider></v-divider>
                  <v-card-text> Limite de Crédito <br>{{formatMXN(user.so_creditlimit) + ' MXN'}}</v-card-text>
                  <v-divider></v-divider>
                  <!-- <v-card-text> Nombre <br>{{user.username}}</v-card-text>
                  <v-divider></v-divider> -->

                </v-card-text> 
                <v-divider class="mt-12"></v-divider> 
              </v-card>
            </v-col>
          </v-row>  
          <v-row justify="center">
            <div>Datos fiscales</div> 
          </v-row>   
          <v-row justify="center">
            <v-col cols="12" sm="10" md="8" lg="6" >
              <v-card ref="form">
                  <!-- 
                <v-card-text>   
                  <v-text-field ref="name" v-model="user.email" label="Email" required></v-text-field>
                  <v-text-field ref="name" v-if="user.taxid != 'XAXX010101000'" 
                  v-model="user.taxid" label="RFC" required></v-text-field> 
                </v-card-text> 
                  -->
                  <v-card-text> Correo <br>{{user.email}}</v-card-text>
                  <v-divider></v-divider>
                  <v-card-text v-if="user.taxid != 'XAXX010101000'" > RFC <br>{{user.taxid}}    </v-card-text>
                  <v-divider></v-divider>
                   <br><br>
              </v-card>
            </v-col>
          </v-row>  
        </div>
    </v-container> 
  </v-main> 
</template>

<script>
  import axios from 'axios'; 
  import config from '../json/config.json'
  import AppMenu from '../components/Menu.vue';

  export default {
    name:"account", 
    data() {
      return {  
        user:{},  
        msgerror : "",
        isLoad : true
      }
    },
    methods:{ 
      formatMXN(value) {
            var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
            return formatter.format(value);
      },
    },  
    components: { 
      'app-menu': AppMenu, 
    },
    async mounted() {    
      window.scrollTo(0,0);
    },
  
    async created(){
      this.isLoad = true;  
          this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        })
        .then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (this.user.status == "success") {
          this.user = this.user.user;
        }
        else{
          this.$router.push('/shop/Login') 
        }
      this.isLoad = false;
    }
  }
</script>