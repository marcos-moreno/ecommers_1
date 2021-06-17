<template>
  <div v-if="isLogged"> 
    <AppMenu/> 
      <v-toolbar>    
          <v-tabs v-model="tab"
            next-icon="mdi-arrow-right-bold-box-outline"
            prev-icon="mdi-arrow-left-bold-box-outline"
            show-arrows
           >
            <v-tabs-slider color="yellow"></v-tabs-slider> 
            <v-tabs v-model="tab" background-color="primary" color="basil" grow dark >
            <v-tab>
              Solicitudes de Proveedor
            </v-tab> 
            <v-tab>
              Clientes
            </v-tab>
            <v-tab>
              Ventas
            </v-tab>
            <v-tab>
              Ordenes Pago en Sucursal
            </v-tab> 
            </v-tabs>  
          </v-tabs> 
      </v-toolbar> 
    <v-card min-height="800px"> 
      <Preregistros v-if="tab==0" />
      <Accounts v-if="tab==1" />
      <Ventas v-if="tab==2" />
    </v-card>
   </div>
</template>  
 
<script> 
import config from '../../json/config.json'
import axios from 'axios'; 
import AppMenu from '../../components/admin/MenuAdmin.vue'; 
import Preregistros from '../../components/admin/Pre-registros.vue'; 
import Accounts from '../../components/admin/Accounts.vue'; 
import Ventas from '../../components/admin/Ventas.vue'; 

 
export default {
  name: "HomeAdmin",  
  data() {
    return { 
      tab : "",
      isLogged : false,
      user : {},
      isLoad : false,
      filter : "",
      valorBuscado : "",
      verfiltro : false
    }; 
  },  
  async created() {   
    this.isLoad = true;  
    await this.validaLogin(); 
    this.isLoad = false;  
  },
  components: { 
        AppMenu, 
        Preregistros,
        Accounts,
        Ventas
  },methods: { 
    async validaLogin(){
        this.user = await axios.get(config.apiAdempiere + "/user/userByTokenAdmin", 
        {'headers': { 'token': this.$cookie.get('token') }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});     
        if (this.user.status == "success") {
          this.user = this.user.user; 
          this.isLogged = true;
        }else if(this.user.status == "unauthorized"){ 
          this.$router.push('/shop/admin'+config.matchAdmin+'/login');
          this.isLogged = false;
        }  
    } 
  },
  
}
</script>
