precision mediump float;                                                                 

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;


void main()
{
	
float rot=(3.14159265359*(mouse.y));

	mat2 rotation=mat2(cos(rot),sin(rot),-sin(rot),cos(rot));
	
float x,y,temp1,temp2,temp3,ypos;

temp1=dot(gl_FragCoord.x,gl_FragCoord.x)*(mouse.x*0.0001);
temp2=dot(gl_FragCoord.y,gl_FragCoord.y)*(mouse.y*0.0001);
	
vec2 pos=vec2(temp1,temp2);
	
pos*=rotation;
	
temp3=pos[0]+pos[1];

x=sqrt(temp3*temp3*temp3);

//y=sqrt(temp3*temp3*temp3);

y=cos(gl_FragCoord.x*3.14159265359*2.0);

    gl_FragColor = vec4(sin(x*y));
}
