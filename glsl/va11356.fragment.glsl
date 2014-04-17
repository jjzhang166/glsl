//Written by Vlad - based on some original effect on here I can't remember :P

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) 
{
  //vec2 resolution = vec2(800, 600);

  vec2 uPos = ( gl_FragCoord.xy / resolution.xy );

  uPos.x -= 10.5;
  uPos.y -= -0.0;

  vec3 color = vec3(0.0);

  float vertColor = 0.0;

  for( float i = 0.0; i < 10.0; ++i )
  {
    float t = time * (0.75);
  
    uPos.y -= ( (sin(cos( uPos.y*(i+2.0) + t+i/2.0)) * 0.2) - (tan(cos( uPos.y*(i+0.25) + t+i/0.25)) * 0.15));
    uPos.x += ( (tan(cos( uPos.x*(i+2.0) + t+i/2.0)) * 0.2) - (sin(cos( uPos.y*(i+0.25) + t+i/0.25)) * 0.15));

    uPos.y -= ( (sin(cos( uPos.y*(i+2.0) + t+i/2.0)) * 0.2) - (tan(cos( uPos.y*(i+0.25) + t+i/0.25)) * 0.15));
    uPos.x += ( (tan(cos( uPos.x*(i+2.0) + t+i/2.0)) * 0.2) - (sin(tan( uPos.y*(i+0.25) + t+i/0.25)) * 0.15));

    float fTemp = abs(1.0 / (uPos.y * uPos.x) / 800.0);

    vertColor *= fTemp;

    color += vec3( min(fTemp, 10.0) * sin(t), fTemp*i/55.0, sin(fTemp*(1.0-i)/10.0) );

    uPos = ((gl_FragCoord.xy - (resolution * 0.5)) / min(resolution.y,resolution.x) * 1.0) * mouse.xy * 10.0;
  }
  
  vec4 color_final = vec4(color, 1.0);

  gl_FragColor = color_final;

}