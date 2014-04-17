


// Text tutorial - by @h3r3 (you can find me on Twitter)

// This is a very simple (and not fast) way to write vectorial text in a shader.

// As I was request to write some comments on how it works I wrote this small tutorial.

//

// Have fun :)

#ifdef GL_ES

precision mediump float;

#endif

uniform float time;

uniform vec2 mouse;

uniform vec2 resolution;

uniform sampler2D backbuffer;

// Returns true if coordinate pos is contained in the rectangle between upperLeft and lowerRight

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
	return  vec3(-sin(v*4.0+v*2.0+time), sin(u*8.0+v-time), cos(u+v*90.0+time))*16.0;
	
	

}



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

void displayLetters(float x, float y)
{
	vec3 color;
	vec2 p = vec2(gl_FragCoord.x - resolution.x/2., gl_FragCoord.y - resolution.y/2.) / resolution.y;
	 float u = length(p);
	float v = atan(p.y, p.x);
	float t = time / 0.5 + 1.0 / u;
	bool background = false;
	
	float intensity = abs(sin(t * 4.0 + v)+sin(v*4.0)) * .25 * u * 0.25;
    
       
	


    p *=2.5;
    p.x += cos(time) * .3 + .4;
    p.y += sin(time) * .2 - 1.5;

  

    // Example 2: if you want to translate left you have to increase p.x

    p.x += x; // Uncomment to test

    p.y +=y;

  


  

  

    

    if (letterB(vec2(p.x, p.y))) 
    {
	    color +=vec3(1.0, 0.0, 0.0);
  

    	if(tria(p, vec2(.05, .2), vec2(.05, .4), vec2(.2, .25))

       ||tria(p, vec2(.05, .6), vec2(.05, .8), vec2(.15, .65)))
	
      color -= 1.0;
    }
  

//    p *=1.3;

    
    else if (letterR(vec2(p.x - 0.5, p.y))) color += vec3(1.0, 0.0, 0.0); // Uncomment to test, - 0.8 is translation to the right and 0.5 is half opacity

  

    // Or you can write a colorored "r"

   else  if (letterI(vec2(p.x - 1.2, p.y))) color += vec3(1.0, 0.0, 0.1); // Uncomment to test, 1.0 is red component, 0.5 is green component, 0.3 is blue component

  

   //else  if (letterT(vec2(p.x - 1.8, p.y))) color += vec3(1.0, 0.2, 0.2); // Uncomment to test, 1.0 is red component, 0.5 is green component, 0.3 is blue component

   //else  if (letterT(vec2(p.x - 2.5, p.y))) color += vec3(1.0, 0.2, 1.0); // Uncomment to test, 1.0 is red component, 0.5 is green component, 0.3 is blue component

     else 
     {
	    displayBackground();
	    background = true;
     }
  

   


  

  	if(!background){
		float alpha = sin(time);
		color = mix(color, displayBackground(), alpha);
		gl_FragColor = vec4(color * intensity * (u * 20.0), 1.0);
	}
}
void main()

{
	
	for(float x = -2.0; x < 4.5; x+=3.0)
		for(float y = -4.2; y<5.0; y+=3.0)
			displayLetters(x, y);
		
}

