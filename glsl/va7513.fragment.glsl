#ifdef GL_ES
precision mediump float;
#endif

varying lowp vec4 FragColor;
precision mediump float;
uniform lowp vec2 Point;
uniform float Radius;
uniform lowp vec3 FillColor;

void main()
{
   float d = distance(Point, gl_FragCoord.xy);
   if (d < Radius) {
       float a = (Radius - d) * 0.5;
       a = min(a, 1.0);
       gl_FragColor = vec4(FillColor, a);
   } else {
       gl_FragColor = vec4(0);
   }
}