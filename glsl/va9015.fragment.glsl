uniform sampler2D prevBuffer; // previus buffer
uniform sampler2D actBuffer;  // actual buffer

uniform mediump float damping;            // smoothing value between 0.0 - 1.0 

mediump vec2 offset[4];                   // this is going to be the neighbors matrix
void main(){
   mediump vec2 st = gl_FragCoord.xy;   // store the position of the pixel we are working
   // Set the neighbors matrix
   //
   offset[0] = vec2(-1.0, 0.0);
   offset[1] = vec2(1.0, 0.0);
   offset[2] = vec2(0.0, 1.0);
   offset[3] = vec2(0.0, -1.0);

   // "sum" is going to store the total value of the neighbors pixels
   //
   mediump vec3 sum = vec3(0.0);
   for (int i = 0; i < 4 ; i++){
      sum += texture2D(actBuffer, st + offset[i]).rgb;
   }

   // make an average of this total
   //
   sum = sum / 4.0;

   // calculate the diference between that average and the value of the center pixel 
   // this is like adding the velocity
   //
   sum = sum*2.0 - texture2D(prevBuffer, st).rgb;

   // smooth this value
   //
   sum = sum * damping;

   // write this information on the other texture ( buffer )
   //
   gl_FragColor = vec4(sum, 1.0);
}