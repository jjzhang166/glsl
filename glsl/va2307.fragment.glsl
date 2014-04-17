


//Text tutorial - by @h3r3 (you can find me on Twitter)
//Background by @Paulofalcao
// Modified by Ericrius



#ifdef GL_ES

precision mediump float;

#endif

uniform float time;

uniform vec2 mouse;

uniform vec2 resolution;

uniform sampler2D backbuffer;



bool rect(in vec2 pos, in vec2 upperLeft, in vec2 lowerRight) {

    return pos.x > upperLeft.x && pos.y > upperLeft.y && pos.x < lowerRight.x && pos.y < lowerRight.y;

}

// Returns true if coordinate pos is inside triangle with vertices a, b, c

bool tria(in vec2 pos, in vec2 a, in vec2 b, in vec2 c) {

    vec2 v0 = c - a, v1 = b - a, v2 = pos - a;

    float dot00 = dot(v0, v0), dot01 = dot(v0, v1), dot02 = dot(v0, v2), dot11 = dot(v1, v1), dot12 = dot(v1, v2);

    float invDenom = 1. / (dot00 * dot11 - dot01 * dot01);

    float u = (dot11 * dot02 - dot01 * dot12) * invDenom;

    float v = (dot00 * dot12 - dot01 * dot02) * invDenom;

    return (u >= .0) && (v >= .0) && (u + v < 1.);

}

vec3 displayBackground()
{
	
	vec2 pos = gl_FragCoord.xy / resolution - mouse;
	pos.x *= (resolution.x / resolution.y);
	
	float u = length(pos);
	float v = atan(pos.y, pos.x);
	float t = time / 0.5 + 1.0 / u;
	return  vec3(1, sin(u*8.0+v-time)*.3, cos(u+v*90.0+time)*.13)*16.0;
	
	

}

//.h
vec3 sim(vec3 p,float s);
vec2 rot(vec2 p,float r);
vec2 rotsim(vec2 p,float s);

//nice stuff :)
vec2 makeSymmetry(vec2 p){
   vec2 ret=p;
   ret=rotsim(ret,sin(time*0.3)*2.0+3.0);
   ret.x=abs(ret.x);
   return ret;
}

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+tan(t*fx)*sx;
   float yy=y-tan(t*fy)*sy;
   return 0.8/sqrt(abs(x*xx+yy*yy));
}



//util functions
const float PI=3.14159265;

vec3 sim(vec3 p,float s){
   vec3 ret=p;
   ret=p+s/2.0;
   ret=fract(ret/s)*s-s/2.0;
   return ret;
}

vec2 rot(vec2 p,float r){
   vec2 ret;
   ret.x=p.x*cos(r)-p.y*sin(r);
   ret.y=p.x*sin(r)+p.y*cos(r);
   return ret;
}

vec2 rotsim(vec2 p,float s){
   vec2 ret=p;
   ret=rot(p,-PI/(s*2.0));
   ret=rot(p,floor(atan(ret.x,ret.y)/PI*s)*(PI/s));
   return ret;
}
//Util stuff end


bool letterR(in vec2 pos) {

    return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.

       && rect(pos, vec2(.0), vec2(.2, 1.))

       || (pos.x > .2

           && pos.x < .6

           && tria(pos, vec2(-.2,.6), vec2(.4,.9), vec2(1.,.6))

           && !tria(pos, vec2(.2,.6), vec2(.4,.7), vec2(.6,.6)));

}

bool letterB(in vec2 pos) {

    return pos.x>.0 && pos.x<.6 && pos.y>.0 && pos.y<1.

       && tria(pos, vec2(.0), vec2(.0, .6), vec2(.35, .25))

       ||tria(pos, vec2(.0, .4), vec2(.0, 1.0), vec2(.35, .75));

}

bool letterI(in vec2 pos){

    return pos.x > .0 && pos.x <.6 && pos.y>.0 && pos.y <1.

       && rect(pos, vec2(.0), vec2(.2, .7))

       ||rect(pos, vec2(.0, .8), vec2(.2, 1.0));

}

bool letterT(in vec2 pos){

    return pos.x > .0 && pos.x <.6 && pos.y>.0 && pos.y <1.

       && rect(pos, vec2(.0), vec2(.15, 1.0))

       ||rect(pos, vec2(-.3, .5), vec2(.5, .6));

}

vec3 DisplayLetters()
{
	vec3 color;
	vec2 p = vec2(gl_FragCoord.x - resolution.x*.5, gl_FragCoord.y - resolution.y*.5) / resolution.y;
	 float u = length(p);
	float v = atan(p.y, p.x);
	float t = time / 0.5 + 1.0 / u;
	bool background = false;
	
	float intensity = abs(sin(t * 4.0 + v)+sin(v*4.0)) * .25 * u * 0.25+.02;
    	
    p*=2.5;
    p.x += 1.5 ; // Uncomment to test
    p.y +=1.2;
    vec2 letterBPos= p, letterTPos = p, letterRPos = p, letterT2Pos = p, letterIPos = p;
	letterBPos *=.9;
	letterBPos.x-=.2;
	letterTPos.x-=2.5;
	letterT2Pos.x -= 2.13;
	letterRPos.x -=0.1;
	letterIPos.x -=1.2;
	
	

      
	
     if(!letterB(vec2(letterBPos.x += sin(time * 2.)*.7, letterBPos.y+=sin(time*2.0)-.5)+.1)&&!letterR(vec2(letterRPos.x -=sin(time*2.0)*.7, letterRPos.y))&&!letterI(letterIPos * (cos(time*.1) + 1.0) * 1. + .1)&& !letterT(vec2(letterTPos.x +=sin(time * 2.0), letterTPos.y))&&!letterT(vec2(letterT2Pos.x-= sin(time*2.0)*.8, letterT2Pos.y = letterBPos.y)))
     {
	background = true;
     }
	
  
  	if(!background){
		float alpha = .5;
		color = mix(color, displayBackground(), alpha);
		return vec3(color * intensity * (u * 20.0));
	}
	else return vec3(0, 0, 0);
}







void main()

{
   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);
   p=p*2.0;
  
   p=makeSymmetry(p);
   
   float x=p.x;
   float y=p.y;
   
   float t=time*0.5;

   float a=
       makePoint(x,y,3.3,2.9,0.3,0.3,t);
   a=a+makePoint(x,y,1.9,2.0,0.4,0.4,t);
   a=a+makePoint(x,y,0.8,0.7,0.4,0.5,t);
   a=a+makePoint(x,y,2.3,0.1,0.6,0.3,t);
   a=a+makePoint(x,y,0.8,1.7,0.5,0.4,t);
   a=a+makePoint(x,y,0.3,1.0,0.4,0.4,t);
   a=a+makePoint(x,y,1.4,1.7,0.4,0.5,t);
   a=a+makePoint(x,y,1.3,2.1,0.6,0.3,t);
   a=a+makePoint(x,y,1.8,1.7,0.5,0.4,t);   
   
   float b=
       makePoint(x,y,1.2,1.9,0.3,0.3,t);
   b=b+makePoint(x,y,0.7,2.7,0.4,0.4,t);
   b=b+makePoint(x,y,1.4,0.6,0.4,0.5,t);
   b=b+makePoint(x,y,2.6,0.4,0.6,0.3,t);
   b=b+makePoint(x,y,0.7,1.4,0.5,0.4,t);
   b=b+makePoint(x,y,0.7,1.7,0.4,0.4,t);
   b=b+makePoint(x,y,0.8,0.5,0.4,0.5,t);
   b=b+makePoint(x,y,1.4,0.9,0.6,0.3,t);
   b=b+makePoint(x,y,0.7,1.3,0.5,0.4,t);

   float c=
       makePoint(x,y,3.7,0.3,0.3,0.3,t);
   c=c+makePoint(x,y,1.9,1.3,0.4,0.4,t);
   c=c+makePoint(x,y,0.8,0.9,0.4,0.5,t);
   c=c+makePoint(x,y,1.2,1.7,0.6,0.3,t);
   c=c+makePoint(x,y,0.3,0.6,0.5,0.4,t);
   c=c+makePoint(x,y,0.3,0.3,0.4,0.4,t);
   c=c+makePoint(x,y,1.4,0.8,0.4,0.5,t);
   c=c+makePoint(x,y,0.2,0.6,0.6,0.3,t);
   c=c+makePoint(x,y,1.3,0.5,0.5,0.4,t);
   
   vec3 d=vec3(a,b,c)/31.0;
   
   vec3 letterColor = DisplayLetters();
   
   vec3 backgroundColor = vec3(d.x,d.y,d.z);
   vec3 color = mix (letterColor, backgroundColor, 0.35);
   gl_FragColor = vec4(color, 1.0);
       
}

