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
        
        <v-alert v-if="msg!=''" border="right" colored-border type="success" elevation="2">
            {{msg}}
        </v-alert> 
    </v-container> 

    <v-container v-if="!isCrud" style="min-width: 80%;"> 
        <template> 
            <div> 
                <v-row>
                    <v-col>
                        <v-btn color="primary" @click="refresh()" label="refresh" fab  small  dark ><v-icon>mdi-cached</v-icon></v-btn>
                    </v-col> 
                </v-row>
            </div>
            <v-card >
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

    <v-container v-else> 
        <template>   
            <v-container>
                <template>
                    <v-item-group multiple>
                        <v-container>
                        <v-row>
                            <v-col >
                            <v-item >
                                <v-card  class="d-flex align-center"  min-height="100">  
                                <div class="my-5 flex-grow-1 text-center">
                                    <v-container class="grey lighten-5">
                                        <v-row style="font-size: 0.9em;color :#909090">
                                            <v-col  cols="6" md="4">
                                                <div>Orden de Venta</div><div style="color :#000" >{{venta.documentno}}</div>
                                            </v-col>
                                            <v-col cols="6" sm="4">
                                                <div>Método de pago</div><div style="color :#000"> {{getTipoPago(venta.method_pay)}} </div>
                                            </v-col>
                                            <v-col cols="6" sm="4">
                                                <div>Estado del pago</div><div style="color :#000">{{venta.status_pay=="pendiente"?"Pendiente": (venta.status_pay=="pagado"?"Pagado": venta.status_pay)}}</div>
                                            </v-col>
                                            <v-col cols="6" sm="4">
                                                <div>Total</div><div style="color :#000">{{formatMXN(venta.grandtotal)}}</div> 
                                            </v-col>
                                            <v-col  cols="6" sm="4">
                                                <div>Entrega</div> <div style="color :#000"> {{venta.status_entrega=="pendiente"?"Pendiente": (venta.status_entrega=="entregado"?"Entregado": venta.status_entrega)}}</div>
                                            </v-col>
                                            <v-col  cols="6" sm="4">
                                                <div>Fecha Compra</div><div style="color :#000">{{formatDate(venta.created_at)}} {{formatTime(venta.created_at)}}</div>
                                            </v-col> 
                                            <v-col  cols="6" sm="4">
                                                <div>Entrega en</div><div style="color :#000">{{buscaSucursal(venta.ad_org_recpt_id)}}</div>
                                            </v-col> 
                                            <v-col  cols="6" sm="4">
                                                <div>Fecha programada para la entrega</div> 
                                                <div style="color :#000" v-if="venta.fechaprometida == undefined">
                                                    Disponible hasta confirmar el pago 
                                                </div>
                                                <div v-else style="color :#000">
                                                    {{formatDate(venta.fechaprometida)}} a partir de las {{venta.horaprometida}}:00 hrs.
                                                </div> 
                                            </v-col>     
                                            <v-col  cols="6" sm="4">
                                                <div>No. Factura</div><div style="color :#000">{{venta.documentnoInvoice}}</div>
                                            </v-col>
                                            <v-col  cols="6" sm="4">
                                                <div>No. Traspaso</div><div v-if="venta.resultMovement!=undefined" style="color :#000">{{venta.resultMovement.documentno}}</div>
                                            </v-col>
                                            <v-col  cols="6" sm="4">
                                                <div>Email Cliente</div><div style="color :#000">{{venta.emailClient}}</div>
                                            </v-col> 
                                        </v-row> 
                                    </v-container> 

                                    <v-expansion-panels>
                                    <v-expansion-panel>
                                        <v-expansion-panel-header>
                                        <center>Productos</center>
                                        </v-expansion-panel-header>
                                        <v-expansion-panel-content> 
                                        <v-row class="my-2">
                                            <v-col cols="12" md="4" v-for="producto in venta.productos" :key="producto.value">
                                                <v-card class="mx-auto" max-width="500" outlined>
                                                    <v-row >
                                                        <v-col  cols="12" md="4">
                                                            <v-img  width="150px" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`" aspect-ratio="1" class="grey lighten-2"> 
                                                                <template v-slot:placeholder>
                                                                    <v-row class="fill-height ma-0" align="center" justify="center">
                                                                    <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                                                                    </v-row>
                                                                </template> 
                                                            </v-img> 
                                                        </v-col>
                                                            <v-col  cols="12" md="8">
                                                                <div class="my-2" style="font-size: 0.8em;color :#909090"> {{producto.name.substring(0,45) + "..."}} </div>
                                                            <v-row>
                                                                <v-col><div style="font-size: 0.8em;color :#909090">Total</div>{{formatMXN(producto.total)}} </v-col>
                                                                <v-col><div style="font-size: 0.8em;color :#909090">Cantidad</div>{{producto.quantity}} </v-col>
                                                            </v-row>
                                                            <v-row>
                                                                <v-col><div style="font-size: 0.8em;color :#909090">Código: {{producto.value}}</div></v-col>
                                                            </v-row>  
                                                        </v-col>
                                                    </v-row> 
                                                </v-card> 
                                            </v-col> 
                                        </v-row> 
                                        </v-expansion-panel-content>
                                    </v-expansion-panel>
                                    </v-expansion-panels>
                                    
                                    <v-expansion-panels class="my-5">
                                        <v-expansion-panel>
                                            <v-expansion-panel-header>
                                            <center>Transacción en Adempiere</center>
                                            </v-expansion-panel-header>
                                            <v-expansion-panel-content> 
                                                <v-row style="font-size: 0.9em;color :#909090">
                                                    <v-col  cols="6" sm="4">
                                                        <div>Insertar Orden</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultOrder" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>
                                                    <v-col  cols="6" sm="4">
                                                        <div>Completar Orden</div>
                                                        <div style="color :#000"> 
                                                            <vue-json-pretty :path="'res'" :data="venta.resultOrderComplete" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>
                                                    <v-col  cols="6" sm="4">
                                                        <div>Insertar Traspaso</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultMovement" > </vue-json-pretty>
                                                        </div>
                                                    </v-col>
                                                    <v-col  cols="6" sm="4">
                                                        <div>Completar Traspaso</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultMovementComplete" > </vue-json-pretty>
                                                        </div>
                                                    </v-col> 
                                                    <v-col  cols="6" sm="4">
                                                        <div>Insertar Factura</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultcreateInvoiceWS" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>
                                                    <v-col  cols="6" sm="4">
                                                        <div>Insertar Líneas de Factura</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultInvoiceLinesAD" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>
                                                     <v-col  cols="6" sm="4">
                                                        <div>Completar Factura</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultcompleteInvoiceWS" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>  
                                                    <v-col  cols="6" sm="4">
                                                        <div>Crear pago</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultcreatePaymentWS" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>
                                                     <v-col  cols="6" sm="4">
                                                        <div>Completar pago</div>
                                                        <div style="color :#000">  
                                                            <vue-json-pretty :path="'res'" :data="venta.resultcompletePaymentWS" > </vue-json-pretty>
                                                        </div> 
                                                    </v-col>  
                                                </v-row> 
                                            </v-expansion-panel-content> 
                                        </v-expansion-panel>
                                    </v-expansion-panels>
                                    <br>
                                    <v-row>  
                                        <v-col  cols="6" sm="4" v-if="venta.status_pay == 'pendiente' && venta.method_pay == 'TRA'">
                                            <v-btn height="50" color="primary" @click="completaPago(true,venta)">
                                                <v-img style="margin:7px" src="../../../public/credito.svg" width="40" ></v-img>
                                                Confirmar Pago recibido
                                            </v-btn>
                                        </v-col>  
                                        <v-col  cols="6" sm="4" v-if="venta.status_pay == 'pendiente'  && venta.method_pay == 'TRA'">
                                            <v-btn height="50" color="warning" @click="completaPago(false,venta)">
                                                <v-img style="margin:7px" src="../../../public/credito.svg" width="40" ></v-img>Declinar Pago
                                                </v-btn>
                                        </v-col>  
                                    </v-row> 
                                </div>   
                                </v-card>
                            </v-item>
                            </v-col>
                        </v-row>
                        </v-container>
                    </v-item-group>
                </template>
            </v-container>    
        </template>
    </v-container>   
   </div>
</template>

<script>  
import axios from 'axios'; 
import config from '../../json/config.json';  
import VueJsonPretty from 'vue-json-pretty';
import 'vue-json-pretty/lib/styles.css';

export default { 
    data: () => ({ 
        search: '',
        headers: [
          { text: 'No. Orden', value: 'documentno' },
          {
            text: 'Cliente',
            align: 'start',
            // filterable: false,
            value: 'nombre_cliente',
          },   
          { text: 'Total de la venta', value: 'grandtotalFormato' },
          { text: 'Método de pago', value: "formaPagoText" }, 
          { text: 'Estado de pago', value: 'status_pay_com'},   
          { text: 'Fecha de compra', value: 'creat_at'},   
          { text: 'Fecha de entrega', value: 'fechaprometidaFormato'},  
          { text: 'Actions', value: 'actions', sortable: false },
        ], 
        isLoad:false,
        msgError:'',
        msg : '',
        isCrud:false, 
        dialog : false,
        venta : {},
        ventas:[],
        sucursales:[],
        recoleccion : {}
    }),components: { 
         VueJsonPretty,
    },
    async created(){  
       await this.getAllVentas(); 
        this.allSucursales();
    }, 
    methods: {
        async buscarDiasRuta(){ 
            this.recoleccion = {};
            this.recoleccion = await axios.get(config.apiAdempiere + "/sucursal/get_dias_entrega"
                ,{  
                    headers: { 
                        'token': this.$cookie.get('token') 
                    },
                    params:{
                        saleOrder:this.venta,
                        sucursal:{ad_org_id:this.venta.ad_org_recpt_id}
                    }
                }
            ).then(res=>{
                return res.data.data;
            }).catch(err=>{console.log(err);return false;});
            console.log(this.recoleccion); 
            if (this.recoleccion != false) {
                this.venta.fechaprometida = this.recoleccion.fecha; 
                this.venta.fechaprometidatexto = this.recoleccion.texto; 
                this.venta.horaprometida = this.recoleccion.hora;  
                return true;
            }else{
                 return false;
            }
        }, 
        async completaPago(pagado,venta){
            this.isLoad = true; 
            await this.buscarDiasRuta();
            if (this.venta.fechaprometida == undefined|| this.venta.fechaprometida=='') {
                this.msgError = "Existe un error, la fecha de entrega no se pudo calcular";
                return;
            }
            this.venta.status_pay = pagado ? "pagado":"Cancelado"; 
            this.venta.status_pay = pagado ? "pagado":"Cancelado";
            const result = await axios.post(
                config.apiAdempiere + "/saleorder/pagotransferencia", 
                this.venta
            ,{headers:{'token': this.$cookie.get('token')}})
            .then(res=>{
                return res.data;
            }).catch(err=>{
                console.log(err);
                this.msgError = err;
                return false;
            });
            this.isLoad = false;
            if(result.status == "success"){ 
                this.venta = result.data;
                venta = result.data;
                console.log(venta);
                this.msg = "Procesado correctamente";   
                return true;
            }else{
                window.scrollTo(0,0);
                if (result.data == "Error Interno") {
                    this.msgError = "Existe un error, por favor Comuníquese con el soporte al número: 55 3937 3022";
                }else{
                    this.msgError = result.data;
                } 
                return false; 
            } 
        },
        async allSucursales(){ 
            this.sucursales = await axios.get(config.apiAdempiere + "/sucursal/get_auth", 
            {
            'headers': { 'token': this.$cookie.get('token') }
            }).then(res=>{return  res.data.data;})
            .catch(err=>{return err;}); 
        },
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
                case "TRA":
                    formaPagoText = "TRANSFERENCIA ELECTRÓNICA"
                break;
                default:
                    formaPagoText = "NO DEFINIDO"
                break; 
            }   
            return formaPagoText;
        },  
        buscaSucursal(idOrg){ 
            let nombreSucursal = "";
            this.sucursales.forEach(element => {
                if (element.ad_org_id == idOrg)nombreSucursal = element.name;
            });
            return nombreSucursal;
        }, 
        returnTable(){
            this.isCrud = false;
            this.msgError = "";
            this.msg = "";
        },
        formatMXN(value) {
        var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
        return `${formatter.format(value)} MXN`;
        },
        formatDate(dates) { 
            var month= ["Enero","Febrero","Marzo","Abril","Mayo","Junio","Julio",
                "Agosto","Septiembre","Octubre","Nobiembre","Diciembre"];  
            return `${(new Date(Date.parse(dates))).getDate()} de ${month[(new Date(Date.parse(dates))).getMonth()]} del ${(new Date(Date.parse(dates))).getFullYear()}`
        },
        formatTime(dates) { 
            const hours = ('0' + (new Date(Date.parse(dates))).getHours()).slice(-2)
            const minutes = ('0' + (new Date(Date.parse(dates))).getMinutes()).slice(-2)
            return `${hours}:${minutes}`
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
                    if (this.ventas[index].fechaprometida == null || this.ventas[index].fechaprometida == undefined) {
                          this.ventas[index].fechaprometidaFormato = 'No definida'
                    }else{
                        this.ventas[index].fechaprometidaFormato = this.formatDate(this.ventas[index].fechaprometida);
                    }
                    this.ventas[index].formaPagoText = this.getTipoPago(this.ventas[index].method_pay);
                    this.ventas[index].creat_at = this.formatDate(this.ventas[index].created_at);
                    this.ventas[index].status_pay_com = this.ventas[index].status_pay.toUpperCase();
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
 