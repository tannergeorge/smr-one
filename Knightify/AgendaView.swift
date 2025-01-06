//
//  AgendaView.swift
//  SMR One
//
//  Created by Tanner George on 8/6/23.
//

import SwiftUI

struct AgendaView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "completed", ascending: true), NSSortDescriptor(key: "priority", ascending: false), NSSortDescriptor(key: "datestamp", ascending: true)]) var items: FetchedResults<AgendaItem>
    
    @Environment(\.dismiss) var dismiss
    
    @State var presented = false
    @State var editMenu = false
    @State var editItem: AgendaItem?
    @State var newItem = ""
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("app_bg")
                    .edgesIgnoringSafeArea(.all)
                
                ScrollView {
                    VStack {
                        ForEach(items, id: \.self) { item in
                            Button {
                                withAnimation {
                                    item.completed.toggle()
                                    try? moc.save()
                                }
                            } label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                                        .frame(width: .infinity, height: 50)
                                        .foregroundColor(Color("app_bg"))
                                        .shadow(color: .gray, radius: 3, x: 0, y: 0)
                                        .padding([.leading, .trailing])
                                    HStack {
                                        if item.completed == false {
                                            Image(systemName: "checkmark.circle")
                                                .font(.system(size: 24))
                                                .foregroundColor(.green)
                                                .padding(.leading, 20)
                                        } else {
                                            Image(systemName: "checkmark.circle.fill")
                                                .font(.system(size: 24))
                                                .foregroundColor(.green)
                                                .padding(.leading, 20)
                                        }
                                        
                                        if item.completed == false {
                                            Text(item.name ?? "No name found")
                                                .font(.system(size: 20, design: .rounded))
                                                .foregroundColor(Color("text_color"))
                                        } else {
                                            Text(item.name ?? "No name found")
                                                .font(.system(size: 20, design: .rounded))
                                                .foregroundColor(.gray)
                                                .strikethrough()
                                        }
                                        
                                        Spacer()
                                        
                                        Button {
                                            withAnimation {
                                                item.priority.toggle()
                                                try? moc.save()
                                            }
                                        } label: {
                                            if item.priority == false {
                                                Image(systemName: "star.circle")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.yellow)
                                            } else {
                                                Image(systemName: "star.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.yellow)
                                            }
                                        }
                                        
                                        Button {
                                            newItem = item.name!
                                            editItem = item
                                            editMenu = true
                                        } label: {
                                            if item.edited == false {
                                                Image(systemName: "pencil.circle")
                                                    .font(.system(size: 24))
                                            } else {
                                                Image(systemName: "pencil.circle.fill")
                                                    .font(.system(size: 24))
                                            }
                                        }
                                        
                                        Button {
                                            withAnimation {
                                                moc.delete(item)
                                                try? moc.save()
                                            }
                                        } label: {
                                            if item.completed == false {
                                                Image(systemName: "trash.circle")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.red)
                                            } else {
                                                Image(systemName: "trash.circle.fill")
                                                    .font(.system(size: 24))
                                                    .foregroundColor(.red)
                                            }
                                        }
                                        .padding(.trailing, 20)
                                    }
                                }
                            }
                        }
                    }
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Button {
                            presented = true
                            newItem = ""
                        } label: {
                            Image(systemName: "plus.circle")
                                .font(.system(size: 28))
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .buttonBorderShape(.capsule)
                        .shadow(color: .blue, radius: 3, x: 0, y: 0)
                    }
                }
                                    
            }
            .navigationTitle("Tasks")
            .sheet(isPresented: $presented) {
                NavigationStack {
                    VStack {
                        Spacer()
                        TextField("Item name", text: $newItem)
                            .font(.system(size: 26, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding([.top, .leading, .trailing])
                            .padding(.bottom, 5)
                            .textFieldStyle(.roundedBorder)
                        Spacer()
                        Button {
                            let item = AgendaItem(context: moc)
                            item.id = UUID()
                            item.name = newItem
                            item.originalName = newItem
                            item.datestamp = Date.now
                            item.completed = false
                            item.priority = false
                            item.edited = false
                            
                            withAnimation {
                                try? moc.save()
                            }
                            
                            newItem = ""
                            presented = false
                        } label: {
                            HStack {
                                Spacer()
                                Text("Add")
                                    .font(.system(size: 18, design: .rounded))
                                Spacer()
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                    }
                    .navigationTitle("Add item")
                }
                .presentationDetents([.height(250)])
            }
            .sheet(isPresented: $editMenu) {
                NavigationStack {
                    VStack {
                        Spacer()
                        TextField("New name", text: $newItem)
                            .textFieldStyle(.roundedBorder)
                            .font(.system(size: 26, design: .rounded))
                            .multilineTextAlignment(.center)
                            .padding()
                        Spacer()
                        
                        if UIDevice.current.userInterfaceIdiom == .pad {
                            HStack {
                                Button {
                                    withAnimation {
                                        editItem!.completed.toggle()
                                        try? moc.save()
                                    }
                                    editMenu = false
                                } label: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "checkmark")
                                            .font(.system(size: 24))
                                        Text("Complete")
                                            .font(.system(size: 18, design: .rounded))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .tint(.green)
                                .padding()
                                
                                Button {
                                    //Star
                                    withAnimation {
                                        editItem!.priority.toggle()
                                        try? moc.save()
                                    }
                                    editMenu = false
                                } label: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "star.fill")
                                            .font(.system(size: 24))
                                        Text("Star")
                                            .font(.system(size: 18, design: .rounded))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .tint(.yellow)
                                .padding()
                                
                                Button {
                                    //Delete
                                    withAnimation {
                                        moc.delete(editItem!)
                                        try? moc.save()
                                    }
                                    editMenu = false
                                } label: {
                                    HStack {
                                        Spacer()
                                        Image(systemName: "trash.fill")
                                            .font(.system(size: 24))
                                        Text("Delete")
                                            .font(.system(size: 18, design: .rounded))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.borderedProminent)
                                .controlSize(.large)
                                .tint(.red)
                                .padding()
                            }
                            //Spacer()
                        }
                        
                        HStack {
                            Button {
                                withAnimation {
                                    editItem!.edited = true
                                    editItem!.name = newItem
                                    try? moc.save()
                                }
                                editMenu = false
                            } label: {
                                HStack {
                                    Spacer()
                                    Text("Save")
                                        .font(.system(size: 18, design: .rounded))
                                    Spacer()
                                }
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                            .padding()
                            
                            if editItem?.edited == true {
                                Button {
                                    withAnimation {
                                        editItem!.edited = false
                                        editItem!.name = editItem!.originalName
                                        try? moc.save()
                                    }
                                    editMenu = false
                                } label: {
                                    HStack {
                                        Spacer()
                                        Text("Revert")
                                            .font(.system(size: 18, design: .rounded))
                                        Spacer()
                                    }
                                }
                                .buttonStyle(.bordered)
                                .controlSize(.large)
                                .tint(.red)
                                .padding()
                            }
                        }
                    }
                    .navigationTitle("Edit")
                }
                .presentationDetents([.height(250)])
            }
        }
    }
}

struct AgendaView_Previews: PreviewProvider {
    static var previews: some View {
        AgendaView()
    }
}
