/* sawtooth staircase pixel shader -- created by swyter */

  //          0.f
  //       _  A
  //      |_| |
  //      |_| |
  //      |_| |
  //      |_| |
  //      |_| | Y
  //      |_| |
  //      |_| |
  //      |_| |
  //          V
  //  0.f <-> 1.f
  //       X

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void )
{
    int frame_count  = 8;                          // número total de cuadros de animación
    int frame_height = 64;                         // píxeles verticales de cada cuadro, no tiene que variar
    int total_height = frame_count * frame_height; // píxeles verticales en toda la imagen
 
    float tiem = time / float(frame_count);        // en vez de pasar por todos los cuadros cada segundo hacemos que cada cuadro dure un segundo
    float sawtooth = tiem - floor(tiem);           // va de cero a uno y vuelve a empezar, se resta a sí mismo (57.3 - 57 = .3)

    float thing = 1.0;

    thing /= float(frame_count);                   // escalamos las coordenadas verticales reduciéndolas para mostrar sólo el primer cuadro (1/8)
  
  
    thing += floor(sawtooth * float(frame_count)); // expandimos el contador de 0.0-1.0 al número de cuadros 0.0-8.0, y nos deshacemos de los decimales, dejando un valor entero por lo que 3.7 -> 3.0
    thing /= float(frame_count);                   // lo escalamos de vuelta normalizándolo al rango 0-1, eso sí, ahora saltará de un cuadro al siguiente bruscamente, sin deslizarse
    
    gl_FragColor = vec4(thing,thing,0,1);

  
  //float sawtooth = time + 10. - floor(time + 10.);
  //gl_FragColor = vec4(sawtooth*(1.-sawtooth), 0, 0, 0);
}
