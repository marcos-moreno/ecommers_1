<template>
  <v-main>
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
        <div v-if="!isLoad">
          <v-row justify="center">
            <div>Datos de cuenta</div> 
          </v-row>  
          <v-row justify="center">
            <v-col cols="12" sm="10" md="8" lg="6" >
              <v-card ref="form"> 
                <v-card-text> 
                  <v-text-field ref="name" v-model="user.username" label="Nombre" required></v-text-field>
                  <v-text-field ref="name" v-model="user.phone2" label="Celular" required></v-text-field>
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
                <v-card-text> 
                  <v-text-field ref="name" v-model="user.email" label="Email" required></v-text-field>
                  <v-text-field ref="name" v-model="user.taxid" label="RFC" required></v-text-field>
                </v-card-text> 
                <v-divider class="mt-12"></v-divider> 
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
  export default {
    name:"account", 
    data() {
      return {  
        user:{},  
        msgerror : "",
        isLoad : false
      }
    },
    methods:{ 
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
        else if(this.user.status == "unauthorized"){
          this.$router.push('/shop/Login') 
        }
      this.isLoad = false;
    }
  }
</script>