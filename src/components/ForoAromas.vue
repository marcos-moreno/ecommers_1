<template>
    <v-card color="basil" >
    <v-card-title class="text-center justify-center py-6">
      <h1 class="font-weight-bold text-h5 basil--text">
        ¿QUÉ AROMAS MANEJAN?
      </h1>
    </v-card-title> 
    <v-card-title color="basil" class="justify-center"> 
            <v-list color="basil"  max-width="400">
            <v-list-group  prepend-icon="mdi-ticket" v-for="clasearoma in items" :key="clasearoma.name" no-action >
                <template v-slot:activator>
                <v-list-item-content>
                    <v-list-item-title v-text="clasearoma.name"></v-list-item-title>
                </v-list-item-content>
                </template> 
                <v-list-item v-for="aroma in clasearoma.values" :key="aroma">
                <v-list-item-content>
                    <v-list-item-title v-text="aroma"></v-list-item-title>
                </v-list-item-content>
                </v-list-item>
            </v-list-group>
            </v-list>
    </v-card-title> 
</v-card>
</template> 

<script>
  export default {
    data: () => ({ 
      items: [
        {
          name: 'FRUTALES',
          values: ["California Sun","Cereza","Chicle","Coco","Frambuesa","Fresa","Frutos Rojos","Mango"
                    ,"Manzana","Melocotón","Melón","Granada","Manzana Verde","Cacao Banana"]
        },
        {
          name: 'FLORALES',
          values: ["Flor de Azahar","Jazmín","Rosa","Rosa Damascena","Violet South Grasse","Floral","Agua de Flores"
          ,"Flor de Tahití","Dama de Noche","Edén","Sakura","Renacer"]
        },
        {
          name: 'LINEA AIR CAR',
          values: ["Angel","One","ºF","The Man","Homme"]
        },
        {
          name: 'LINEA ELITE CLASS ONE',
          values: ["One Billion","One VIP","One Exclusive"]
        },
        {
          name: 'AROMATICOS/CÍTRICOS',
          values: ["Aromatherapy","Pack Top"]
        },
        { 
          name: 'ESPECIADOS',
          values: ["Especias de la India","Té Moruno","Té Negro"]
        },
        {
          name: 'BOLSAS',
          values: ["Aromas de Andalucía","Air Natur Home"]
        },
        {
          name: 'DIFUSOR',
          values: ["Esencia","Fragancia"]
        },
        {
          name: 'AMADERADOS',
          values: ["Pino","White Amber"]
        },
        {
          name: 'DULCES',
          values: ["Algodón de Azúcar","Vainilla","Piruleta","Fresa Cremosa","Tarta de Manzana","Romance"]
        },
        {
          name: 'FRESCOS',
          values: ["Antitabaco","Bosque","Coche Nuevo","Cool Black","Océano","Polar","Té Verde","Pino Salvaje"
          ,"Baby Touch","Danza Balinesa","Estrella de Mar","Mediterráneo","Sky","Storm"]
        },
        {
          name: 'CÍTRICOS',
          values: ["Naranja","Limón","Limón Pera","Brisa Cítrica","Zero Car"]
        }, 
        {
          name: 'AROMATICOS',
          values: ["Eucalipto","Lavanda","Menta","Jabón"]
        },
        {
          name: 'BALSAMICOS',
          values: ["Café","Flor de Vainilla","Agua de Coco"]
        },
        {
          name: 'AROMATICOS/CÍTRICOS/ESPECIADO',
          values: ["Pack Starter"]
        },
        {
          name: 'FLORALES/AMADERADO',
          values: ["Al-Andalus","Unforgettable"]
        },
        {
          name: 'FLORALES/FRUTALES',
          values: ["World Edition","Unforgettable"]
        },
        {
          name: 'NEUTRO',
          values: ["Neutro"]
        },
      ],
    }),
  }
</script>

<style>
.basil {
  /* background-color: #FFFBE6 !important; */
}
.basil--text {
  color: #356859 !important;
}
</style>