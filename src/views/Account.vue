<template>
  <v-main>
    <v-container class="my-6"> 
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
        msgerror : ""
      }
    },
    methods:{ 
    },  
    async mounted() {    
      window.scrollTo(0,0);
    },
    async created(){  
          this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        })
        .then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (this.user.status == "success") {
          this.user = this.user.user;
          // console.log(this.user);
        }
        else if(this.user.status == "unauthorized"){
          this.$router.push('/shop/Login') 
        }
    }
  }
</script>