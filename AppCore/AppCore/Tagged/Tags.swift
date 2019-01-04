//
//  Tags.swift
//  StoryCore
//
//  Created by Daniel Asher on 28/07/2018.
//  Copyright © 2018 LEXI LABS. All rights reserved.
//
public enum WordTag { }
public typealias Word = Tagged<WordTag, String>

public enum PhraseTag { }
public typealias Phrase = Tagged<PhraseTag, String>

public enum SentenceTag { }
public typealias Sentence = Tagged<SentenceTag, String>

public enum RatioTag { }
public typealias Ratio = Tagged<RatioTag, Double>

public enum PercentageTag { }
public typealias Percentage = Tagged<PercentageTag, Double>
