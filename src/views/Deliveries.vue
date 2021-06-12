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
                            <v-col  cols="6" md="4">
                                <div>Orden de Venta</div>
                                <div style="color :#000" >{{purchase.documentno}}</div>
                            </v-col>
                            <v-col cols="6" sm="4">
                                <div>Método de pago</div> 
                                <div style="color :#000">
                                    {{  purchase.method_pay=="EFE"?"Pago en sucursal": (purchase.method_pay=="CRE"?"Crédito":
                                     (purchase.method_pay=="paypal"?"Paypal":"Error de pago"))}}
                                     ({{purchase.estado_pago}})
                                </div>
                            </v-col>
                            <v-col cols="6" sm="4">
                                <div>Estado del pago</div> 
                                <div style="color :#000"> 
                                  {{purchase.status_pay}}
                                </div>
                            </v-col>
                            <v-col cols="6" sm="4">
                                <div>Total</div>
                                <v-row>
                                    <v-col style="color :#000">{{formatMXN(purchase.grandtotal)}}</v-col>
                                </v-row> 
                            </v-col>
                            <v-col  cols="6" sm="4">
                                <div>Entrega</div> 
                                <div style="color :#000">{{purchase.status_entrega}}</div>
                            </v-col>
                            <v-col  cols="6" sm="4">
                                <div>Fecha Compra</div>
                                <div style="color :#000">{{formatDate(purchase.created_at)}} {{formatTime(purchase.created_at)}}</div>
                            </v-col> 
                            <v-col  cols="6" sm="4">
                                <v-btn x-small text color="primary" >
                                    Ver Entregas
                                </v-btn>
                            </v-col> 
                            <v-col  cols="6" sm="4">
                                <v-btn x-small text color="primary" >
                                    Ver Factura
                                </v-btn>
                            </v-col> 
                        </v-row>  
                        </v-container>

                        <v-divider></v-divider>
 
                        <v-row class="my-2">
                            <v-col cols="12" md="4" v-for="producto in purchase.productos" :key="producto.value">
                                <v-card class="mx-auto" max-width="500" outlined @click="seeProduct(producto.value)" >
                                    <v-row>
                                        <v-col  cols="12" md="4">
                                            <v-img class="mx-auto" width="150px" :src="producto.img" ></v-img>
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
export default {
  name: "CrudDepartment",
  data() {
    return { 
      page: 1,
      purchases : [],
      isLogged : false,
      user : {},
      isLoad : false, 
      msgErro : ""
    }; 
  }, 
  async created() {
    this.isLoad = true;  
    await this.validaLogin();
    if (this.isLogged) {
      await this.allPurchases();
    }else{
      this.menu('/shop/Login/');  
    } 
    this.isLoad = false;  
  }
  ,components: { 
        'app-menu': AppMenu, 
  },
  methods: { 
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
        console.log(puchases);
        if (puchases.status == "success") { 
            this.purchases = puchases.data; 
            for (let ip = 0; ip < this.purchases.length; ip++) {  
                for (let index = 0; index < this.purchases[ip].productos.length; index++) {   
                    if (this.purchases[ip].productos[index].prodCompleto.status == "success") { 
                        let img = await axios.get(config.apiAdempiere + "/productos/imgByValue"
                          ,{headers: { 'token': this.$cookie.get('token') },params: {filter: this.purchases[ip].productos[index].value}})
                          .then(function (response) {  
                            return response.data.data;
                          }).catch(function (response){  
                            console.log(response);
                            return response;
                          });
                        if (img.length == 1) {
                          img = img[0].img;
                          this.purchases[ip].productos[index].img = 'data:image/jpeg;base64,' + btoa(
                              new Uint8Array(img.data).reduce((data, byte) => data + String.fromCharCode(byte), '')
                          );  
                        }else{ 
                          this.purchases[ip].productos[index].img = "/noImg.png";
                        }
                    }
                } 
            }  
        }else if(this.user.status == "unauthorized"){  
            this.menu('/shop/Login/');
        }  
    } 
    ,seeProduct(value){ 
      this.$router.push('/shop/Product/'+value+"/purchases/0");
    }
    ,formatMXN(value) {
        var formatter = new Intl.NumberFormat('en-ES', {style: 'currency', currency: 'USD',});
        return `MXN ${formatter.format(value)}`;
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
