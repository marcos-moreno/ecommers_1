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
                    :headers="headers" :items="ventas" :search="search">
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

    <!-- <v-container v-if="isCrud">   
        <form >    
            <div class="my-10"> 
                <v-btn 
                    v-if="solicitud.estado_solicitud != 'AU' 
                            && solicitud.estado_solicitud != 'SE' 
                            && solicitud.estado_solicitud != 'SD'"
                        class="ma-2" color="primary">
                    <v-icon left dark>mdi-checkbox-marked-circle</v-icon>
                    Aprobar Solicitud
                </v-btn> 
            </div>
        </form>
    </v-container>   -->
    </div>
</template>

<script>  
import axios from 'axios'; 
import config from '../../json/config.json';   
export default { 
    data: () => ({ 
        search: '',
        headers: [
          { text: 'Orden', value: 'documentno' },
          {
            text: 'Cliente',
            align: 'start',
            // filterable: false,
            value: 'nombre_cliente',
          },   
          { text: 'Total', value: 'grandtotalFormato' },
          { text: 'Método de pago', value: "formaPagoText" }, 
          { text: 'Fecha de compra', value: 'creat_at'},   
          { text: 'Fecha de entrega', value: 'fechaprometidaFormato'},   
        //   { text: 'Actions', value: 'actions', sortable: false },
        ], 
        msgError:'',
        isCrud:false, 
        dialog : false,
        venta : {},
        ventas:[]
    }),components: { 
    },
    async created(){  
       await this.getAllVentas(); 
    }, 
    methods: {
        getTipoPago(value){
            let formaPagoText = '';
            switch (value.toUpperCase()) {
                case "CRE":
                    formaPagoText = "CRÉDITO REFIVIDRIO"
                break;
                case "EFE":
                    formaPagoText = "PAGO EN SUCURSAL"
                break;
                case "PAYPAL":
                    formaPagoText = "PAGO INMEDIATO PAYPAL"
                break;
                default:
                    formaPagoText = "No DEFINIDO"
                break; 
            }   
            return formaPagoText;
        }, 
        formatMXN(value) {
            var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
            return formatter.format(value);
        }, 
        returnTable(){
            this.isCrud = false;
            this.msgError = "";
        },
        formatDate(dates) {
            if (dates === undefined)return "Error de Fecha" 
            try {
                var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio","Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
                let date = new Date(Date.parse(dates));  
                return `${date.getDate()} de ${month[date.getMonth()]} del ${date.getFullYear()}`;
            } catch (error) {
                console.log(error);
                return "Error de Fecha";
            }
        }, 
        async getAllVentas(){ 
            this.isLoad = true;
            this.ventas = await axios.get(config.apiAdempiere + "/saleorder/get_allSales",
            { headers:{token: this.$cookie.get('token')}, data:{filer: {}}})
            .then(res=>{return res.data;})
            .catch(err=>{return err;});
            if (this.ventas.status == "success") {
                this.ventas = this.ventas.data; 
                for (let index = 0; index < this.ventas.length; index++) { 
                    this.ventas[index].grandtotalFormato = this.formatMXN(this.ventas[index].grandtotal);
                    this.ventas[index].fechaprometidaFormato = this.formatDate(this.ventas[index].fechaprometida);
                    this.ventas[index].formaPagoText = this.getTipoPago(this.ventas[index].method_pay);
                    this.ventas[index].creat_at = this.formatDate(this.ventas[index].created_at);
                }
            }
            this.isLoad = false;
        },
        async refresh(){
            await this.getAllVentas(); 
        },
        async crud(item){
            this.msgError = "";
            this.isCrud = true;
            this.venta = item;  
        }, 
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

 