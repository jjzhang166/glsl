#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float i_scale = 50.0;
const float blend = 1.0;

vec2 p;
vec3 color = vec3(0.0);

float point(vec2 point){
   vec2 c = p - point;
   c = c*c;
	
   float sum = c.x + c.y;
   
   //return sin(2.0*time) * blend * sin(sum)/sum;
   return blend * sin(sum)/sum;
}

float movePoint(float fx,float fy,float sx,float sy){
   vec2 mp = vec2(sin(time*fx)*sx, cos(time*fy)*sy);
   return point(mp);
}


void main( void ) {

   //get by uniform constants----------------------------------
   float aspect = resolution.x/resolution.y;
	
   p = gl_FragCoord.xy/resolution.y;
   p.y -= 0.5;
   p.x -= aspect * 0.5;
   p *= i_scale;
	
   vec2 m_n = vec2(aspect * (mouse.x - .5), mouse.y - .5);
   m_n *= i_scale;
   //----------------------------------------------------------
	
   /*color.x += movePoint(3.3,2.9, 0.3,0.3);
   color.x += movePoint(1.9,2.0, 0.4,0.4);
   color.x += movePoint(0.8,0.7, 0.4,0.5);
   color.x += movePoint(2.3,0.1, 0.6,0.3);
   color.x += movePoint(0.8,1.7, 0.5,0.4);
   color.x += movePoint(0.3,1.0, 0.4,0.4);
   color.x += movePoint(1.4,1.7, 0.4,0.5);
   color.x += movePoint(1.3,2.1, 0.6,0.3);
   color.x += movePoint(1.8,1.7, 0.5,0.4);   
   
   color.y += movePoint(1.2,1.9, 0.3,0.3);
   color.y += movePoint(0.7,2.7, 0.4,0.4);
   color.y += movePoint(1.4,0.6, 0.4,0.5);
   color.y += movePoint(2.6,0.4, 0.6,0.3);
   color.y += movePoint(0.7,1.4, 0.5,0.4);
   color.y += movePoint(0.7,1.7, 0.4,0.4);
   color.y += movePoint(0.8,0.5, 0.4,0.5);
   color.y += movePoint(1.4,0.9, 0.6,0.3);
   color.y += movePoint(0.7,1.3, 0.5,0.4);*/
	
   color.z += point(m_n);
   color.z += point(vec2(-1.5, 1.0));
   color.z += point(vec2(1.5, 1.0));
   color.z += point(vec2(0.0, -1.5));
   color.z += point(vec2(4.0*sin(time), 4.0*cos(time)));

   gl_FragColor = vec4(color, 1.0);
}