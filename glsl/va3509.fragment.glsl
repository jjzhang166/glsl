#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

   vec2 pos = -1.0 + 2.0*gl_FragCoord.xy / resolution.xy;
   float energy = 0.0;
   
   //for (float i=0.0; i<25.0; i+=1.0) {
      //vec2 starPos = vec2( 0.5*sin(i + time), 0.2*cos(i*i + time/16.0) );
      //energy += pow( cos( distance ( pos, starPos ) ), 521.0 );
   //}
   energy += pow(distance(pos, pos*time/2.0), 32.0);
   
   gl_FragColor = vec4( energy/4.0, energy/4.0, energy, 1.0 );
}