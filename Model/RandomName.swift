//
//  RandomName.swift
//  PlacenoteSDKExample
//
//  Created by Neil Mathew on 10/10/19.
//  Copyright © 2019 Placenote. All rights reserved.
//

import Foundation

extension Array {
  func randomItem() -> Element? {
    if isEmpty { return nil }
    let index = Int(arc4random_uniform(UInt32(self.count)))
    return self[index]
  }
}

public class RandomName
{
  public static func Get() -> String {

    let animal = Animals[Int(arc4random_uniform(UInt32(Animals.count)))]

    return animal;
  }

  static let Animals: [String] = [
    "Aardvark",
    "Aardwolf",
    "African buffalo",
    "African elephant",
    "African leopard",
    "Albatross",
    "Alligator",
    "Alpaca",
    "American buffalo (bison)",
    "American robin",
    "Amphibian",
    "List",
    "Anaconda",
    "Angelfish",
    "Anglerfish",
    "Ant",
    "Anteater",
    "Antelope",
    "Antlion",
    "Ape",
    "Aphid",
    "Arabian leopard",
    "Arctic Fox",
    "Arctic Wolf",
    "Armadillo",
    "Arrow crab",
    "Asp",
    "Ass (donkey)",
    "Baboon",
    "Badger",
    "Bald eagle",
    "Bandicoot",
    "Barnacle",
    "Barracuda",
    "Basilisk",
    "Bass",
    "Bat",
    "Beaked whale",
    "Bear",
    "List",
    "Beaver",
    "Bedbug",
    "Bee",
    "Beetle",
    "Bird",
    "List",
    "Bison",
    "Blackbird",
    "Black panther",
    "Black widow spider",
    "Blue bird",
    "Blue jay",
    "Blue whale",
    "Boa",
    "Boar",
    "Bobcat",
    "Bobolink",
    "Bonobo",
    "Booby",
    "Box jellyfish",
    "Bovid",
    "Buffalo, African",
    "Buffalo, American (bison)",
    "Bug",
    "Butterfly",
    "Buzzard",
    "Camel",
    "Canid",
    "Cape buffalo",
    "Capybara",
    "Cardinal",
    "Caribou",
    "Carp",
    "Cat",
    "List",
    "Catshark",
    "Caterpillar",
    "Catfish",
    "Cattle",
    "List",
    "Centipede",
    "Cephalopod",
    "Chameleon",
    "Cheetah",
    "Chickadee",
    "Chicken",
    "List",
    "Chimpanzee",
    "Chinchilla",
    "Chipmunk",
    "Clam",
    "Clownfish",
    "Cobra",
    "Cockroach",
    "Cod",
    "Condor",
    "Constrictor",
    "Coral",
    "Cougar",
    "Cow",
    "Coyote",
    "Crab",
    "Crane",
    "Crane fly",
    "Crawdad",
    "Crayfish",
    "Cricket",
    "Crocodile",
    "Crow",
    "Cuckoo",
    "Cicada",
    "Damselfly",
    "Deer",
    "Dingo",
    "Dinosaur",
    "List",
    "Dog",
    "List",
    "Dolphin",
    "Donkey",
    "List",
    "Dormouse",
    "Dove",
    "Dragonfly",
    "Dragon",
    "Duck",
    "List",
    "Dung beetle",
    "Eagle",
    "Earthworm",
    "Earwig",
    "Echidna",
    "Eel",
    "Egret",
    "Elephant",
    "Elephant seal",
    "Elk",
    "Emu",
    "English pointer",
    "Ermine",
    "Falcon",
    "Ferret",
    "Finch",
    "Firefly",
    "Fish",
    "Flamingo",
    "Flea",
    "Fly",
    "Flyingfish",
    "Fowl",
    "Fox",
    "Frog",
    "Fruit bat",
    "Gamefowl",
    "List",
    "Galliform",
    "List",
    "Gazelle",
    "Gecko",
    "Gerbil",
    "Giant panda",
    "Giant squid",
    "Gibbon",
    "Gila monster",
    "Giraffe",
    "Goat",
    "List",
    "Goldfish",
    "Goose",
    "List",
    "Gopher",
    "Gorilla",
    "Grasshopper",
    "Great blue heron",
    "Great white shark",
    "Grizzly bear",
    "Ground shark",
    "Ground sloth",
    "Grouse",
    "Guan",
    "List",
    "Guanaco",
    "Guineafowl",
    "List",
    "Guinea pig",
    "List",
    "Gull",
    "Guppy",
    "Haddock",
    "Halibut",
    "Hammerhead shark",
    "Hamster",
    "Hare",
    "Harrier",
    "Hawk",
    "Hedgehog",
    "Hermit crab",
    "Heron",
    "Herring",
    "Hippopotamus",
    "Hookworm",
    "Hornet",
    "Horse",
    "List",
    "Hoverfly",
    "Hummingbird",
    "Humpback whale",
    "Hyena",
    "Iguana",
    "Impala",
    "Irukandji jellyfish",
    "Jackal",
    "Jaguar",
    "Jay",
    "Jellyfish",
    "Junglefowl",
    "Kangaroo",
    "Kangaroo mouse",
    "Kangaroo rat",
    "Kingfisher",
    "Kite",
    "Kiwi",
    "Koala",
    "Koi",
    "Komodo dragon",
    "Krill",
    "Ladybug",
    "Lamprey",
    "Landfowl",
    "Land snail",
    "Lark",
    "Leech",
    "Lemming",
    "Lemur",
    "Leopard",
    "Leopon",
    "Limpet",
    "Lion",
    "Lizard",
    "Llama",
    "Lobster",
    "Locust",
    "Loon",
    "Louse",
    "Lungfish",
    "Lynx",
    "Macaw",
    "Mackerel",
    "Magpie",
    "Mammal",
    "Manatee",
    "Mandrill",
    "Manta ray",
    "Marlin",
    "Marmoset",
    "Marmot",
    "Marsupial",
    "Marten",
    "Mastodon",
    "Meadowlark",
    "Meerkat",
    "Mink",
    "Minnow",
    "Mite",
    "Mockingbird",
    "Mole",
    "Mollusk",
    "Mongoose",
    "Monitor lizard",
    "Monkey",
    "Moose",
    "Mosquito",
    "Moth",
    "Mountain goat",
    "Mouse",
    "Mule",
    "Muskox",
    "Narwhal",
    "Newt",
    "New World quail",
    "Nightingale",
    "Ocelot",
    "Octopus",
    "Old World quail",
    "Opossum",
    "Orangutan",
    "Orca",
    "Ostrich",
    "Otter",
    "Owl",
    "Ox",
    "Panda",
    "Panther",
    "Panthera hybrid",
    "Parakeet",
    "Parrot",
    "Parrotfish",
    "Partridge",
    "Peacock",
    "Peafowl",
    "Pelican",
    "Penguin",
    "Perch",
    "Peregrine falcon",
    "Pheasant",
    "Pig",
    "Pigeon",
    "List",
    "Pike",
    "Pilot whale",
    "Pinniped",
    "Piranha",
    "Planarian",
    "Platypus",
    "Polar bear",
    "Pony",
    "Porcupine",
    "Porpoise",
    "Portuguese man o' war",
    "Possum",
    "Prairie dog",
    "Prawn",
    "Praying mantis",
    "Primate",
    "Ptarmigan",
    "Puffin",
    "Puma",
    "Python",
    "Quail",
    "Quelea",
    "Quokka",
    "Rabbit",
    "List",
    "Raccoon",
    "Rainbow trout",
    "Rat",
    "Rattlesnake",
    "Raven",
    "Ray (Batoidea)",
    "Ray (Rajiformes)",
    "Red panda",
    "Reindeer",
    "Reptile",
    "Rhinoceros",
    "Right whale",
    "Roadrunner",
    "Rodent",
    "Rook",
    "Rooster",
    "Roundworm",
    "Saber-toothed cat",
    "Sailfish",
    "Salamander",
    "Salmon",
    "Sawfish",
    "Scale insect",
    "Scallop",
    "Scorpion",
    "Seahorse",
    "Sea lion",
    "Sea slug",
    "Sea snail",
    "Shark",
    "List",
    "Sheep",
    "List",
    "Shrew",
    "Shrimp",
    "Silkworm",
    "Silverfish",
    "Skink",
    "Skunk",
    "Sloth",
    "Slug",
    "Smelt",
    "Snail",
    "Snake",
    "List",
    "Snipe",
    "Snow leopard",
    "Sockeye salmon",
    "Sole",
    "Sparrow",
    "Sperm whale",
    "Spider",
    "Spider monkey",
    "Spoonbill",
    "Squid",
    "Squirrel",
    "Starfish",
    "Star-nosed mole",
    "Steelhead trout",
    "Stingray",
    "Stoat",
    "Stork",
    "Sturgeon",
    "Sugar glider",
    "Swallow",
    "Swan",
    "Swift",
    "Swordfish",
    "Swordtail",
    "Tahr",
    "Takin",
    "Tapir",
    "Tarantula",
    "Tarsier",
    "Tasmanian devil",
    "Termite",
    "Tern",
    "Thrush",
    "Tick",
    "Tiger",
    "Tiger shark",
    "Tiglon",
    "Toad",
    "Tortoise",
    "Toucan",
    "Trapdoor spider",
    "Tree frog",
    "Trout",
    "Tuna",
    "Turkey",
    "List",
    "Turtle",
    "Tyrannosaurus",
    "Urial",
    "Vampire bat",
    "Vampire squid",
    "Vicuna",
    "Viper",
    "Vole",
    "Vulture",
    "Wallaby",
    "Walrus",
    "Wasp",
    "Warbler",
    "Water Boa",
    "Water buffalo",
    "Weasel",
    "Whale",
    "Whippet",
    "Whitefish",
    "Whooping crane",
    "Wildcat",
    "Wildebeest",
    "Wildfowl",
    "Wolf",
    "Wolverine",
    "Wombat",
    "Woodpecker",
    "Worm",
    "Wren",
    "Xerinae",
    "X-ray fish",
    "Yak",
    "Yellow perch",
    "Zebra",
    "Zebra finch"
  ]
}
