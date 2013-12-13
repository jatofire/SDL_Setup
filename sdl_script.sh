#Code by Christo

#! /bin/bash

args=("$@")


st=${args[0]}${args[1]}${args[2]}

if [ -d $st ]; then
	echo "Project already exists!"
	exit
else
	echo "Creating project.."
	mkdir $st
	mkdir $st"//assets"
	mkdir $st"//assets//Images"
	mkdir $st"//assets//Sounds"
	mkdir $st"//assets//Music"
	mkdir $st"//assets//Fonts"
	mkdir $st"//src"
	mkdir $st"//bin"
	touch $st"//src//main.cpp"	
fi
declare -a classArray
let classCount=0
while [ true ]; do
	echo "Enter class name: (exit to well... exit)"
	read class
	if [ "$class" == "exit" ]; then
		break
	else
		echo "Creating "$class".cpp"
		echo "Creating "$class".h"
		#touch $st"//src//"$class".cpp " $st"//src//"$class".h"
		classArray[$classCount]=$class
		((classCount++))
	fi
done

echo ${classArray[@]}

echo "#include <iostream>" >> $st"//src//main.cpp"
echo "#include <SDL/SDL.h>" >> $st"//src//main.cpp"

for i in ${classArray[@]}
do
	echo "#include \"$i".h\" >> $st"//src//main.cpp"
done

echo "" >> $st"//src//main.cpp"
echo "int main(int argc, char **argv)" >> $st"//src//main.cpp"
echo "{" >> $st"//src//main.cpp"
echo "" >> $st"//src//main.cpp"
echo "    int screen_width = 640;" >> $st"//src//main.cpp"
echo "    int screen_height = 480;" >> $st"//src//main.cpp"
echo "    int bpp = 32;" >> $st"//src//main.cpp"
echo "    SDL_Event event;" >> $st"//src//main.cpp"
echo "    bool running = true;" >> $st"//src//main.cpp"
echo "    SDL_Surface *screen = SDL_SetVideoMode(screen_width, 
										   screen_height,
										   bpp,
										   SDL_SWSURFACE);" >> $st"//src//main.cpp"
echo "    SDL_Init(SDL_INIT_EVERYTHING);" >> $st"//src//main.cpp"
echo "" >> $st"//src//main.cpp"
echo "    SDL_WM_SetCaption( \""$st"\", NULL );" >> $st"//src//main.cpp"
echo "    while(running)" >> $st"//src//main.cpp"
echo "    {" >> $st"//src//main.cpp"
echo "        while(SDL_PollEvent(&event))" >> $st"//src//main.cpp"
echo "        {" >> $st"//src//main.cpp"
echo "            switch(event.type)" >> $st"//src//main.cpp"
echo "            {" >> $st"//src//main.cpp"
echo "                case SDL_QUIT:" >> $st"//src//main.cpp"
echo "                    running = false;" >> $st"//src//main.cpp"
echo "                    break;" >> $st"//src//main.cpp"
echo "            }" >> $st"//src//main.cpp"
echo "            break;" >> $st"//src//main.cpp"
echo "        }" >> $st"//src//main.cpp"
echo "" >> $st"//src//main.cpp"
echo "" >> $st"//src//main.cpp"
echo "    SDL_Delay(1000/60);" >> $st"//src//main.cpp"
echo "    SDL_Flip(screen);" >> $st"//src//main.cpp"
echo "    }" >> $st"//src//main.cpp"


echo "" >> $st"//src//main.cpp"
echo "    SDL_Quit();" >> $st"//src//main.cpp"
echo "    return 0;" >> $st"//src//main.cpp"
echo "}" >> $st"//src//main.cpp"

for i in ${classArray[@]}
do
	#populate header files with simple contructor
	echo "#ifndef "$i"_H" >> $st"//src//"$i".h"
	echo "#define "$i"_H" >> $st"//src//"$i".h"
	echo "#include <SDL/SDL.h>" >> $st"//src//"$i".h"
	echo "#include <SDL/SDL_image.h>" >> $st"//src//"$i".h"
	echo "" >> $st"//src//"$i".h"
	echo "class C"$i >> $st"//src//"$i".h"
	echo "{" >> $st"//src//"$i".h"
	echo "" >> $st"//src//"$i".h"
	echo "" >> $st"//src//"$i".h"
	echo "    public:" >> $st"//src//"$i".h"
	echo "    C"$i"();" >> $st"//src//"$i".h"
	echo "    ~C"$i"();" >> $st"//src//"$i".h"
	echo "" >> $st"//src//"$i".h"
	echo "};" >> $st"//src//"$i".h"
	echo "#endif" >> $st"//src//"$i".h"
	
	#populate source files with simple contructor
	echo "#include \""$i".h\"" >> $st"//src//"$i".cpp"
	echo "" >> $st"//src//"$i".cpp"
	echo "C"$i"::C"$i"()" >> $st"//src//"$i".cpp"
	echo "{" >> $st"//src//"$i".cpp"
	echo "" >> $st"//src//"$i".cpp"
	echo "}" >> $st"//src//"$i".cpp"
	
	echo "C"$i"::~C"$i"()" >> $st"//src//"$i".cpp"
	echo "{" >> $st"//src//"$i".cpp"
	echo "" >> $st"//src//"$i".cpp"
	echo "}" >> $st"//src//"$i".cpp"
	
done

declare -a tempArray
count=0;
for k in ${classArray[@]}
do
	tempArray[count]=""$k".o"
	((count++))
done
echo $st": main.o" ${tempArray[@]} >> $st"//src//Makefile"
echo "	g++ -o" $st "main.o" ${tempArray[@]} "-lSDL -lSDL_image" >> $st"//src//Makefile"
echo "" >> $st"//src//Makefile"
echo "main.o: main.cpp" >> $st"//src//Makefile"
echo "	g++ -c main.cpp" >> $st"//src//Makefile"
echo "" >> $st"//src//Makefile"
for i in ${classArray[@]}
do
	echo $i".o: "$i".cpp" >> $st"//src//Makefile"
	echo "	g++ -c "$i".cpp" >> $st"//src//Makefile"
	echo "" >> $st"//src//Makefile"
done

echo "clean:" >> $st"//src//Makefile"
echo "	rm -f *.o "$st >> $st"//src//Makefile"

cd $st"/src"
make
cd ".."
cp "src/"$st "bin/"$st
cd "src/"

count=0;
for k in ${classArray[@]}
do
	tempArray[count]=""$k".cpp"
	((count++))
done
declare -a newtempArray

for k in ${classArray[@]}
do
	newtempArray[count]=""$k".h"
	((count++))
done


echo ${tempArray[@]}
gedit "main.cpp" ${tempArray[@]} ${newtempArray[@]} &

cd ".."
cd "bin/"
./$st

cd ".."
echo "./bin/"$st >> "run.sh"

echo "cd \"src/\"" >> "build.sh"
echo "make" >> "build.sh"
echo "cd \"..\"" >> "build.sh"
echo "cp \"src/"$st"\" \"bin/"$st"\"" >> "build.sh"

echo "cd \"src/\"" >> "buildandrun.sh"
echo "make" >> "buildandrun.sh"
echo "cd \"..\"" >> "buildandrun.sh"
echo "cp \"src/"$st"\" \"bin/"$st"\"" >> "buildandrun.sh"

echo "./bin/"$st >> "buildandrun.sh"

chmod +x "run.sh"
chmod +x "build.sh"
chmod +x "buildandrun.sh"



