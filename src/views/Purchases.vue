<template> 
  <div>
  <app-menu/>
  <v-container class="grey lighten-5" style="min-height:756px;"  >
    <div class="text-center">
      <v-dialog v-model="isLoad" persistent width="300">
         <v-card color="primary" dark >
          <v-card-text>
            cargando
            <v-progress-linear indeterminate color="white" class="mb-0"></v-progress-linear>
          </v-card-text>
        </v-card> 
      </v-dialog>
      
      <v-dialog  v-model="dialogdiasentrega"  width="800"> 
        <v-card>
          <v-card-title style="background:#004996;color:#fff;">HORARIOS DISPONIBLES</v-card-title> 
          <v-card-text>
            <v-radio-group > 
              <v-card dark color="#385F73" class="mx-auto">
                <v-card-title style="font-size:14px">
                  {{sucursal.name}}
                </v-card-title>
                 <center style="font-size:14px">
                  No. Orden: {{purchase.documentno}}
                </center>
                <br>
              </v-card>
              <v-list>  
                <v-radio-group>  
                  <v-list-group v-for="dia in diasEntrega" :key="dia.fecha">
                    <template v-slot:activator>
                      <v-list-item-content>
                        <v-list-item-title>
                          <v-card color="transparent">{{dia.valor}}</v-card>
                        </v-list-item-title>
                      </v-list-item-content>
                    </template> 
                      <v-list-item v-for="dia in diasEntrega" :key="dia.fecha">
                        <v-list-item-content>
                          <v-list-item-title>
                            <v-radio :label="dia.valor" :value="dia" ></v-radio> 
                          </v-list-item-title>
                        </v-list-item-content>
                      </v-list-item>
                  </v-list-group>
                </v-radio-group> 
              </v-list>  
            </v-radio-group>
          </v-card-text>
          <v-divider></v-divider> 
          <v-card-actions>
            <v-spacer></v-spacer>
            <v-btn color="primary" text @click="dialogdiasentrega = false" >
              Guardar
            </v-btn>
          </v-card-actions>
        </v-card>
      </v-dialog>

    </div>
    <template >
      <v-tabs >
        <v-tab>Compras ({{purchasesLength}})</v-tab> 
      </v-tabs>
    </template>
    <v-container class="my-12" v-if="purchasesLength > 0">
      <template>
        <v-item-group multiple>
            <v-container>
            <v-row v-for="purchase in purchases" :key="purchase._id">
                <v-col >
                <v-item >
                    <v-card  class="d-flex align-center"  min-height="100">  
                      <div class="my-5 flex-grow-1 text-center">
                        <v-container class="grey lighten-5">
                        <v-row style="font-size: 0.9em;color :#909090">
                            <v-col  cols="5" md="4">
                                <div>Orden de Venta</div>
                                <div style="color :#000" ><strong>{{purchase.documentno}}</strong></div>
                            </v-col>

                            <div v-if="purchase.method_pay == 'TRA' &&
                             (purchase.status_pay=='pendiente' || purchase.status_pay=='Cancelado' || purchase.requiresdate==true)" 
                             cols="6" sm="4">
                            </div>
                            <v-col v-else cols="7" sm="4">
                                <v-btn text color="primary" @click="acuse(purchase)">
                                    Imprimir orden
                                </v-btn>
                            </v-col>
                            <!-- <v-col v-if="purchase.method_pay == 'TRA' && purchase.requiresdate==true" cols="7" sm="4">
                                <v-btn depressed color="primary" @click="asignarfechaRecoleccion(purchase)">
                                  Fecha Entrega
                                </v-btn>
                            </v-col>  -->
                            <v-col  cols="6" sm="4">
                              <!-- <div>Fecha programada para la entrega</div> 
                              <div style="color :#000" v-if="purchase.method_pay == 'TRA' &&
                                (purchase.requiresdate==true || purchase.status_pay == 'pendiente')">
                                <div style="color :red">Aún no asignada</div>
                              </div>
                              <div style="color :#000" v-else>
                                {{formatDate(purchase.fechaprometida)}}
                              </div> -->
                              <!-- {{purchase.fechaprometida}} -->

                              <div>Fecha disponible para la entrega</div>  
                              <div style="color :#000" v-if="purchase.fechaprometida == undefined">
                                Disponible hasta confirmar tu pago 
                              </div>
                              <div v-else style="color :#000">
                                {{formatDate(purchase.fechaprometida)}} a partir de las {{purchase.horaprometida}}:00 hrs.
                              </div>

                            </v-col>
                          
                          

                            <v-col cols="6" sm="4">
                                <div>Método de pago</div> 
                                <div style="color :#000">
                                    {{buscarTipoPago(purchase.method_pay)}} 
                                     <!-- ({{purchase.estado_pago}}) -->
                                </div>
                            </v-col>
                            <v-col cols="6" sm="4">
                                <div>Estado del pago</div> 
                                <div style="color :#000"> 
                                  {{purchase.status_pay=="pendiente"?"Pendiente": (purchase.status_pay=="pagado"?"Pagado": purchase.status_pay)}} 
                                </div>
                            </v-col>
                            <v-col cols="6" sm="4">
                                <div>Total</div>
                                <v-row>
                                    <v-col style="color :#000"><strong>{{formatMXN(purchase.grandtotal)}}</strong></v-col>
                                </v-row> 
                            </v-col>
                            <v-col  cols="6" sm="4">
                                <div>Entrega</div> 
                                <div style="color :#000"> 
                                  {{purchase.status_entrega=="pendiente"?"Pendiente": 
                                  (purchase.status_entrega=="entregado"?"Entregado": purchase.status_entrega)}} 

                                </div>
                            </v-col>
                            <v-col  cols="6" sm="4">
                                <div>Fecha Compra</div>
                                <div style="color :#000">{{formatDate(purchase.created_at)}} {{formatTime(purchase.created_at)}}</div>
                            </v-col> 
                            
                            <v-col  cols="6" sm="4">
                                <div>Entrega en</div>
                                <div style="color :#000">{{buscaSucursal(purchase.ad_org_recpt_id)}}</div>
                            </v-col>  
                            <!-- <v-col  cols="6" sm="4">
                                <v-btn x-small text color="primary" >
                                    Ver Entregas
                                </v-btn>
                            </v-col> 
                            <v-col  cols="6" sm="4">
                                <v-btn x-small text color="primary" >
                                    Ver Factura
                                </v-btn>
                            </v-col>  -->
                        </v-row>  
                        </v-container>
 
                        <v-expansion-panels>
                          <v-expansion-panel>
                            <v-expansion-panel-header>
                              <center>Productos</center>
                            </v-expansion-panel-header>
                            <v-expansion-panel-content>
                          

                              <v-row class="my-2">
                                  <v-col cols="12" md="4" v-for="producto in purchase.productos" :key="producto.value">
                                      <v-card class="mx-auto" max-width="500" outlined @click="seeProduct(producto.value)" >
                                          <v-row >
                                              <v-col  cols="12" md="4">
                                                <v-img  width="150px" :src="`https://refividrio.com.mx/imgdis/${producto.value}.jpg`" :lazy-src="`../../public/noImg.png`"
                                                          aspect-ratio="1" class="grey lighten-2"> 
                                                    <template v-slot:placeholder>
                                                      <v-row class="fill-height ma-0" align="center" justify="center">
                                                        <v-progress-circular indeterminate color="grey lighten-5" ></v-progress-circular>
                                                      </v-row>
                                                    </template> 
                                                  </v-img> 
                                                  <!-- <v-img class="mx-auto" width="150px" :src="producto.img" ></v-img> -->
                                              </v-col>
                                              <v-col  cols="12" md="8">
                                                  <div v-if="producto.prodCompleto.data.length > 0" class="my-2" style="font-size: 0.8em;color :#909090">
                                                      {{producto.prodCompleto.data[0].name.substring(0,45) + "..."}}
                                                  </div>  
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


                      </div>   
                    </v-card>
                </v-item>
                </v-col>
            </v-row>
            </v-container>
        </v-item-group>
      </template>
    </v-container>   

    <v-container v-if="purchasesLength == 0 && isLoad == false"  style="min-height:656px;"  >
      <div>
        <v-card style="min-height:186px;"> 
            <p class="text-center" style="font-size: 2em;color :#909090">  
              <br> 
             Aún no tienes compras.
            </p> 
        </v-card> 
      </div>  
    </v-container>
  </v-container> 
  </div>
</template>

<style scoped>
    .centered-input >>> input {
      text-align: center
    }
</style>

<script>
import config from '../json/config.json'
import axios from 'axios'; 
import AppMenu from '../components/Menu.vue';
import jsPDF from 'jspdf';
import 'jspdf-autotable';
export default {
  name: "CrudDepartment",
  data() {
    return { 
      page: 1,
      dialogdiasentrega : false,
      purchases : [],
      diasEntrega : [],
      isLogged : false,
      user : {},
      isLoad : false, 
      msgErro : "",
      sucursales:[],
      sucursal: {},
      purchase : {}
    }; 
  }, 
  async created() {
    this.isLoad = true;
    await this.validaLogin();
    if (this.isLogged) {
      await this.allPurchases();
      await this.allSucursales();
    }else{
      this.menu('/shop/Login/');  
    } 
    this.isLoad = false;  
  }
  ,components: { 
        'app-menu': AppMenu, 
  },
  methods: {
    async asignarfechaRecoleccion(compra){   
      this.purchase = compra;
      this.sucursal = {};
      for (let index = 0; index < this.sucursales.length; index++) {
          if(this.sucursales[index].ad_org_id == compra.ad_org_recpt_id) this.sucursal = this.sucursales[index];
      }
      this.diasEntrega = [];
      this.diasEntrega = await axios.get(config.apiAdempiere + "/sucursal/get_dias_entrega"
        ,{headers: { 'token': this.$cookie.get('token') },params: this.sucursal}
      ).then(res=>{
        return res.data.data;
      }).catch(err=>{return err;});
      this.dialogdiasentrega = true;
      console.log(this.diasEntrega);
    },
    buscarTipoPago(method_pay){
      let valur = "";
      switch (method_pay) {
        case "EFE":
          valur = "Pago en sucursal";
        break;
        case "CRE":
          valur = "Crédito";
        break;
        case "paypal":
          valur = "Paypal";
        break;
        case "TRA":
            valur = "Transferencia electrónica"
        break;
        default:
          valur = "No definido";
        break;
      } 
      return valur;
    }, 
    async acuse(data){   
        this.isLoad = true;
        let bodyTBL= []; 
        let totl = (500 + (data.productos.length * 25));
        var doc = new jsPDF('p', 'pt',[500,totl ]);
        var img = new Image()
        img.src = '/refivid.png'; 
        doc.addImage(img,'png', 150, 18, 0, 0);    
        doc.setTextColor(0,106,164);
        doc.setFontSize(11);
        doc.text(40,100,`Estimado/a ${data.nombre_cliente}`);
        doc.text(175,115,`¡Muchas gracias por tu compra!`);
        doc.setTextColor(0,0,0);
        doc.setFontSize(15);
        doc.text(145,140,`Orden de Venta ${data.documentno}`);
        doc.setFontSize(10);
        doc.text(40,165,`Fecha de compra: ${this.formatDate(data.created_at)} ${this.formatTime(data.created_at)}`);
        doc.text(40,180,`Entrega disponible a partir del día: ${this.formatDate(data.fechaprometida)} a las ${data.horaprometida==undefined?0:data.horaprometida}:00 hrs`);
        doc.text(40,195,`Entrega en la Sucursal: ${this.buscaSucursal(data.ad_org_recpt_id)}`);
        doc.text(40,210,`Método de pago: ${this.buscarTipoPago(data.method_pay)}`);
        let counPosition = 245;
        for (let index = 0; index < data.productos.length; index++) {
          const element = data.productos[index]; 
          let imgs = await axios.get(config.apiAdempiere + "/productos/imgByValue"
            ,{headers: { 'token': this.$cookie.get('token') },
            params: {filter: element.value}})
            .then(function (response) {  
              return response.data.data;
            }).catch(function (response){   
              return response;
            });
          if (imgs.length == 1) {
            imgs = imgs[0].img;
            imgs = 'data:image/jpeg;base64,' + btoa(
                new Uint8Array(imgs.data).reduce((data, byte) => data + String.fromCharCode(byte), '')
            ); 
            doc.addImage(imgs,'jpg', 35, counPosition, 40, 40); 
          }
          counPosition += 45; 
          bodyTBL.push([element.name,`${element.quantity} X ${this.formatMXN(element.price)}`,this.formatMXN(element.total)]);
        }  
        doc.autoTable({
          head: [['Producto' ,'Cantidad','Subtotal']],
          margin: { top: 225,left:80 }, 
          bodyStyles: {minCellHeight: 40},
          body: bodyTBL, 
        });
        let finalY = doc.lastAutoTable.finalY;
        doc.setFontSize(15);
        doc.text(180, finalY+20,'Total: ' + this.formatMXN(data.grandtotal));
        doc.setFontSize(10);
        doc.text(45, finalY+38,'Para cualquier duda o aclaración comunicate al télefono 55-5175-7108.');
        if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
            window.open(doc.output("bloburl"), "_blank");   
        } else {
            doc.save(`Orden de venta ${data.documentno}.pdf`);
        }
        this.isLoad = false;
    },  
    async allSucursales(){ 
        this.sucursales = await axios.get(config.apiAdempiere + "/sucursal/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data.data;})
        .catch(err=>{return err;}); 
    },   
    buscaSucursal(idOrg){ 
      let nombreSucursal = "";
      this.sucursales.forEach(element => {
        if (element.ad_org_id == idOrg)nombreSucursal = element.name;
      });
      return nombreSucursal;
    },
    async mounted() {    
      window.scrollTo(0,0);
    },
    menu(path){
      if (this.$route.path !== path){
        this.$router.push(path);
      }  
    },
    async validaLogin(){
         this.user = await axios.get(config.apiAdempiere + "/user/userByToken", 
        {'headers': { 'token': this.$cookie.get('token') }})
        .then(res=>{return res.data;})
        .catch(err=>{return err;});    
        if (this.user.status == "success") {
          this.user = this.user.user; 
          this.isLogged = true;
        }else if(this.user.status == "unauthorized"){ 
          this.isLogged = false;
        }  
    }
    ,async allPurchases(){
        let puchases = await axios.get(config.apiAdempiere + "/saleorder/get_auth", 
        {
          'headers': { 'token': this.$cookie.get('token') }
        }).then(res=>{return res.data;})
        .catch(err=>{return err;});   
        if (puchases.status == "success") { 
            this.purchases = puchases.data; 
        }else if(this.user.status == "unauthorized"){  
            this.menu('/shop/Login/');
        }  
    } 
    ,seeProduct(value){ 
      this.$router.push('/shop/Product/'+value+"/purchases/0");
    }
    ,formatMXN(value) {
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
    }  
  }, 
  computed:{ 
    purchasesLength(){
          return this.purchases.length;
    },  
  },  
}
</script>
