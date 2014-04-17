#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec4 mouse;

void main(void)
{
    //the centre point for each blob
	vec3 move1;// = vec3(0.0, 0.0, 1.0);
	vec3 move2;// = vec3(0.4, 0.0, 0.1);
	vec3 move3;// = vec3(0.8, 0.0, 2.0);
	vec3 move4;// = vec3(1.0, 0.0, 0.5);
	vec3 move5;// = vec3(1.4, 0.0, 4.0);
	vec3 move6;// = vec3(0.5, 0.0, 5.0);
	
	move1.x = cos(sin(1.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move1.y = sin(sin(1.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
	move1.z = 1.0+abs(cos(cos(1.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
	
	move2.x = cos(sin(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move2.y = sin(sin(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
	move2.z = 1.0+abs(cos(cos(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
    
	move3.x = cos(sin(3.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.5;
    move3.y = sin(sin(3.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*0.8;
    move3.z = 1.0+abs(cos(cos(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
	
	move4.x = cos(sin(4.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move4.y = sin(sin(4.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
    move4.z = 1.0+abs(cos(cos(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
	
	move5.x = cos(sin(5.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move5.y = sin(sin(5.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
    move5.z = 1.0+abs(cos(cos(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
	
	move6.x = cos(sin(6.0/3.0*1.0*3.141592654*time*0.1)+time*1.25)*1.5;
    move6.y = sin(sin(6.0/3.0*1.0*3.141592654*time*0.1)+time*1.75)*0.8;
	move6.z = 1.0+abs(cos(cos(2.0/3.0*1.0*3.141592654*time*0.1)+time*1.5)*1.2);
	
    //screen coordinates
    vec2 p = -1.0 + 2.0 * gl_FragCoord.xy / resolution.xy;
    p.x *= resolution.x / resolution.y;
  
    //radius for each blob
    float r1 =(dot(p-move1.xy,p-move1.xy))*64.0*move1.z;
    float r2 =(dot(p-move2.xy,p-move2.xy))*64.0*move2.z;
    float r3 =(dot(p-move3.xy,p-move3.xy))*64.0*move3.z;
    float r4 =(dot(p+move4.xy,p+move4.xy))*64.0*move4.z;
    float r5 =(dot(p+move5.xy,p+move5.xy))*64.0*move5.z;
    float r6 =(dot(p+move6.xy,p+move6.xy))*64.0*move6.z;

    //sum the meatballs
    vec3 meta1 =(1.0/r1)*vec3(1.0,0.3,0.3);
    vec3 meta2 =(1.0/r2)*vec3(0.3,1.0,0.3);
    vec3 meta3 =(1.0/r3)*vec3(0.3,0.3,1.0);
    vec3 meta4 =(1.0/r4)*vec3(1.0,0.1,1.0);
    vec3 meta5 =(1.0/r5)*vec3(1.0,1.0,0.1);
    vec3 meta6 =(1.0/r6)*vec3(0.1,1.0,1.0);
    //alter the cut-off power

    float red     = pow(meta1.x+meta2.x+meta3.x+meta4.x+meta5.x+meta6.x,2.0);
    float green   = pow(meta1.y+meta2.y+meta3.y+meta4.y+meta5.y+meta6.y,2.0);
    float blue    = pow(meta1.z+meta2.z+meta3.z+meta4.z+meta5.z+meta6.z,2.0);
    red   = min(red, 1.0);
    green = min(green, 1.0);
    blue  = min(blue, 1.0);

    //set the output color
    gl_FragColor = vec4(red,green,blue,1.0);
}