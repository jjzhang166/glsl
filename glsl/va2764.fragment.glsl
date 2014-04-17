// By @paulofalcao
//
// Blobs

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;

void main( void ) 
{
   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   vec3 mRGB = vec3(0.5, 0.5, 0.8);

   float a = (sin(p.x * 30.0) * cos(time)) + (sin(p.y * 30.0) * sin(time));
   a = clamp((a * 30.0) - 25.0, 0.0, 1.0);
   
   gl_FragColor = vec4(a * mRGB, 1.0);
}