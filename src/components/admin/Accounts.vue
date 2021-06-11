<template>
    <div> 
    <v-container class="grey lighten-5">
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
    </v-container>
 
    <v-container> 
        <v-btn  v-if="isCrud" icon color="blue" @click="returnTable()"> <v-icon>mdi-arrow-left</v-icon>volver</v-btn>
        <v-divider class="my-2"></v-divider>
        <v-alert v-if="msgError!=''" border="right" colored-border type="error" elevation="2">
            {{msgError}}
        </v-alert>
         <v-alert v-if="msg!=''" border="right" colored-border type="info" elevation="2">
            {{msg}}
        </v-alert>
    </v-container> 

    <v-container v-if="!isCrud"> 
        <template> 
            <div> 
                <v-row>
                    <v-col>
                        <v-btn color="primary" @click="refresh()" label="refresh" fab  small  dark ><v-icon>mdi-cached</v-icon></v-btn>
                    </v-col>
                    <!-- <v-col>
                        <v-select class="my-5" v-model="filterStatus" :items="statusSolicitud" item-text="nombre"
                            :error-messages="error.filterStatus" label="Estatus de solicitud" item-value="code"
                            @change="filtrarRegistros()" >
                        </v-select>
                    </v-col> -->
                </v-row> 
            </div>
            <v-card>
                <v-card-title>
                    <v-text-field v-model="search" append-icon="mdi-magnify" label="Buscar" single-line hide-details
                    ></v-text-field>
                </v-card-title>
                <v-data-table
                    no-data-text="No hay datos disponibles"
                    no-results-text="No hay coincidencias de tu busqueda."
                    :footer-props="{'items-per-page-options': [20,30,40,50]}"
                    :headers="headers" :items="accounts" :search="search">
                    <template v-slot:[`item.actions`]="{ item }">
                        <center>
                            <v-icon color="green darken-2" medium @click="crud(item)">
                                mdi-arrow-up-bold-box-outline
                            </v-icon>
                        </center>
                    </template>
                </v-data-table>
            </v-card>
        </template>
    </v-container> 

    <v-container v-if="isCrud">   
        <form >       
            <v-chip class="ma-2" color="primary"  text-color="white">
                <v-icon left>
                   mdi-star
                </v-icon>
                ID SOCIO: {{account.c_bpartner_id}} 
            </v-chip> 

            <v-chip class="ma-2" color="primary"  text-color="white">
                <v-icon left>
                   mdi-star
                </v-icon>
               ID USUARIO: {{account.ad_user_id}} 
            </v-chip>
 
            <v-text-field v-model="account.cpname" 
                label="*Nombre" name="nombre" id="nombre" required>
            </v-text-field> 
             
            <v-text-field name="phone2" id="phone2" type="text"  v-model="account.phone2" 
                label="*Número Celular" :counter="10"
                onkeydown="javascript: return event.keyCode == 69 ? false : true" style="width:500px">
            </v-text-field>

            <v-text-field style="width:400px" type="text"
                name="email" id="email" v-model="account.email"    label="*Correo Electrónico" required >
            </v-text-field>
             
            <v-row>
                <v-col>
                    <v-text-field disabled name="rfc" id="rfc" v-model="account.taxid"  :counter="13" label="RFC"
                        style="width:400px">
                    </v-text-field>
                </v-col> 
                <v-col>
                    <v-text-field disabled name="listaprecio" id="listaprecio" v-model="account.listaprecio" label="lista de precio"
                        style="width:400px">
                    </v-text-field>
                </v-col> 
                <v-col>
                    <v-text-field disabled name="so_creditlimit" id="so_creditlimit" :value="formatMXN(account.so_creditlimit)"
                     type="text" label="Crédito" style="width:400px">
                    </v-text-field>
                </v-col>  
                 <v-col>
                    <v-text-field disabled name="so_creditused" id="so_creditused" :value="formatMXN(account.so_creditused)"  
                     type="text" label="Crédito Usado" style="width:400px">
                    </v-text-field>
                </v-col>  
            </v-row> 

            <div class="my-10">
                <v-btn  class="ma-2" color="primary" @click="guardar()">
                    <v-icon left dark>mdi-checkbox-marked-circle</v-icon>
                    Guardar Usuario
                </v-btn> 
                <v-btn  class="ma-2" color="error" @click="inactivarUsuario()">
                    <v-icon left dark>mdi-cancel</v-icon>
                    Inactivar Usuario
                </v-btn>
                <v-btn  class="ma-2" color="warning" @click="resetPassword()">
                    <v-icon left dark>mdi-cancel</v-icon>
                    Reset Password
                </v-btn>
            </div>
        </form>
    </v-container>
    </div>
</template>

<script> 
import axios from 'axios'; 
import config from '../../json/config.json';   
export default { 
    data: () => ({
        accounts : [],  
        account : {},
        search: '',
        headers: [ 
            {
                text: 'Nombre',
                align: 'start',
                // filterable: false,
                value: 'cpname',
            },
            { text: 'name2', value: 'name2'},
            { text: 'Usuario ID', value: 'ad_user_id' },
            { text: 'Socio ID', value: "c_bpartner_id" }, 
            { text: 'phone2', value: 'phone2'}, 
            { text: 'RFC', value: 'taxid' },
            { text: 'user', value: 'user' },
            { text: 'username', value: 'username' },
            // { text: 'userpin', value: 'userpin' },
            { text: 'Código', value: 'value' }, 
            { text: 'Actions', value: 'actions', sortable: false },
        ], 
        msgError:'',
        msg:'',
        isCrud:false, 
        isLoad:false,  
        dialog : false,
        user:{}
    }),components: { 
    },
    async created(){ 
       await this.validaLogin();
       await this.getCollections(); 
    },
    computed: { 
    },
    methods: { 
        async guardar(){
            this.isLoad = true;
            this.account.isResetPass = false;
            this.account.Isinactive = false;
            await this.updateUser(); 
            this.isLoad = false;
        },
        async inactivarUsuario(){
            this.isLoad = true;
            this.account.isResetPass = false;
            this.account.Isinactive = true;
            await this.updateUser(); 
            this.isLoad = false;
        },
        async resetPassword(){
            this.isLoad = true;
            this.account.isResetPass = true;
            this.account.Isinactive = false;
            await this.updateUser(); 
            this.isLoad = false;
        },
        async updateUser(){
            const result =  await axios.put(
            config.apiAdempiere + "/user/updateUser", 
            this.account ,{headers:{'token': this.$cookie.get('token')}})
            .then(res=>{ 
                return res.data;
            }).catch(err=>{
                console.log(err);
                this.msgError = "Ocurrio un error, intentalo más tarde."; 
                window.scrollTo(0,0); 
                return false;
            });  
            if (result.status == "success") {
                if (this.account.isResetPass) {
                    this.msg = "Reinicio de contraseña realizado.";
                }
                if (this.account.Isinactive) {
                    this.msg = "Se inactivo el usuario.";
                }
                if (this.account.Isinactive == false && this.account.isResetPass === false) {
                    this.msg = "Se actualizó el usuario.";
                }
                window.scrollTo(0,0); 
            } else {
                this.msgError = result.data.data;
                window.scrollTo(0,0); 
            } 
        },
        returnTable(){
            this.isCrud = false;
            this.msgError = "";
        },
        formatMXN(value) {
            var formatter = new Intl.NumberFormat('en-US', {style: 'currency', currency: 'USD',});
            return formatter.format(value);
        },
        formatMoney(){
            let i = 0;
            while(isNaN(this.solicitud.montPreAprobed)||i==20) {
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace('$', '');
                this.solicitud.montPreAprobed = this.solicitud.montPreAprobed.replace(',', '');
                i++;
            }
            this.solicitud.montPreAprobed = this.formatMXN(this.solicitud.montPreAprobed);
        },
        async getCollections(){
            this.isLoad = true;
            this.accounts = await axios.get(
                config.apiAdempiere + "/user/getAccountAll",
                { headers:{token: this.$cookie.get('token')}, 
                data:{filer: {}}
            }).then(res=>{return res.data;})
            .catch(err=>{return err;}); 
            if (this.accounts.status == "success") this.accounts = this.accounts.data; 
            if(this.preRegistros.status == "unauthorized"){ 
                this.$router.push('/shop/admin'+config.matchAdmin+'/login');
            } 
            else this.accounts = [];   
            this.isLoad = false;
        },
        async refresh(){
            await this.getCollections(); 
        },
        async crud(item){
            this.msgError = "";
            this.isCrud = true;
            this.account = item;    
        }, 
        async validaLogin(){
            this.user = await axios.get(config.apiAdempiere + "/user/userByTokenAdmin", 
            {
                'headers': { 'token': this.$cookie.get('token') }
            }).then(res=>{return res.data;})
            .catch(err=>{return err;});
            if(this.user.status == "unauthorized"){ 
               this.$router.push('/shop/admin'+config.matchAdmin+'/login');      
            } 
        }
    },
  }
</script>

<style lang="scss">
    input[type=number]::-webkit-inner-spin-button, 
    input[type=number]::-webkit-outer-spin-button { 
    -webkit-appearance: none; 
    margin: 0; 
    }

    input[type=number] { -moz-appearance:textfield; }
</style>

 